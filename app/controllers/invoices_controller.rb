class InvoicesController < ApplicationController
  before_filter :authenticate
  before_filter :load_user
  before_filter :owner_or_admin_user
  
  # GET /invoices
  # GET /invoices.xml
  def index
    @invoices = Invoice.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @invoices }
    end
  end

  # GET /invoices/1
  # GET /invoices/1.xml
  def show
    @invoice = Invoice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @invoice }
    end
  end
  
  def email
    @invoice = Invoice.find(params[:id])
    UserNotifier.send_invoice(@invoice.user,@invoice).deliver
    flash[:success] = "A link to your invoice has been emailed to you"
    redirect_to user_invoice_path(@invoice)
  end
  
  private
  def load_user
    @user = User.find(params[:user_id])
  end
  
  def owner_or_admin_user
    unless @user == current_user
      admin_user
    end
  end
  
end
