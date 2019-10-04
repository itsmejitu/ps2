

  class Ps2Controller < ApplicationController
    before_action :jithu


  	def jithu
  		if params[:erase] == "yes"
  			 cookies.delete(:kills)
  			 flash[:notice] = 'removed successfully'
  		else
  			cookies[:kills] = '' if cookies[:kills].nil?
  			if params[:id]
  				cookies[:kills] = cookies[:kills] + params[:id] + " "
  			end
  			@list = cookies[:kills]
  			if cookies[:kills] == ''
  				@ar = []
  			else
  				@ar = @list.split(" ").map { |s| s.to_i}
  			end
  		end
  	end

  	def transcript
  		content = Rails.root.join 'public/transcript.txt'
  		str = content.to_s
  		@filecontent = File.read(str)
  	end

  	def sql
  		content = Rails.root.join 'public/ps2.sql'
  		str = content.to_s
  		@filecontent = File.read(str)
  	end
  	def input
  		content = Rails.root.join 'public/ps2_sql.txt'
  		str = content.to_s
  		@filecontent = File.read(str)
  	end

  	def quotations
      @quotation = Quotation.all
  		if params[:importx]
  			uploaded_io = params[:importx]
  			File.open(Rails.root.join(uploaded_io.original_filename), 'wb') do |file|
  				file.write(uploaded_io.read)
  			end
  			##read data from quotes.xml file
  			@xmlk = File.open(uploaded_io.original_filename)
  			@data = Hash.from_xml(@xmlk)

  			require 'nokogiri'

  			@doc = 	Nokogiri::XML(open(uploaded_io.original_filename))
  			@obj = @doc.css('object')
  			if @obj = []
  				@obj = @doc.css('quotation')
  			end
  			@va = []
  			@obj.each do |prms|
  				@an = prms.css('author-name').inner_text
  				@ct = prms.css('category').inner_text
  				@qt = prms.css('quote').inner_text
  				@crea = Quotation.create(author_name: @an, category: @ct, quote: @qt)
  			end
  		end
  		if params[:importxurl]
  			@link = params[:importxurl]
  			require 'nokogiri'
  			require 'open-uri'
  			@docc = Nokogiri::HTML(open(@link.to_s))
  			@objj = @docc.css('object')
                          if @objj = []
                                  @objj = @docc.css('quotation')
                          end
                          @vaa = []
                          @objj.each do |prrms|
                                  @ann = prrms.css('author-name').inner_text
                                  @ctt = prrms.css('category').inner_text
                                  @qtt = prrms.css('quote').inner_text
                                  @creaa = Quotation.create(author_name: @ann, category: @ctt, quote: @qtt)
                          end

  		end
  		if params[:term]
  			if params[:term]== ''

  			else
  				q = "%#{params[:term]}%"
  				if q == " "
  					@tasks = []
  				else
  					@tasks = Quotation.where(["lower(quote) LIKE ? OR lower(author_name) LIKE ?", q.downcase, q.downcase ])
  				end
  			end
  		end

      @list_of_categories = Quotation.distinct.pluck(:category)

      if params[:quotation]
  			@dt = params[:quotation]

  			@quotation = Quotation.new(params.require(:quotation).permit( :author_name, :category, :quote))
  			if @quotation.save
  				flash[:notice] = 'Quotation was successfully created.'
  				@quotation = Quotation.new
    		end
  		else
  			@quotation = Quotation.new
  		end
  		if params[:export]
  			@export = Quotation.new
  		else
  			@export = Quotation.new
  		end
  		if params[:sort_by] == "date"
  			@quotations = Quotation.where.not(id: @ar ).order(:created_at)
  		else
  			@quotations = Quotation.where.not(id: @ar ).order(:category)
  		end
  		respond_to do |format|
  			format.html
  			format.xml { render :xml => @quotations }
  			format.json { render json: @quotations }
  		end
  		if params[:export_as] == "jsn"
  			@quotationjson = @quotations.to_json
  			send_data @quotationjson, :type => 'application/json; header=present', :disposition => "attachment; filename=quotes.json"
  		end
  		if params[:export_as] == "xmll"
  			@quotationxml = @quotations.as_json.to_xml.to_s
  			send_data @quotationxml, :type => 'application/xml; header=present', :disposition => "attachment; filename=quotes.xml"
  		end

    end
  end
