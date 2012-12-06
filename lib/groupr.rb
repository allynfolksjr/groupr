require 'net/http'
require 'nokogiri'
class Groupr
	attr_accessor :api_url, :certificate, :key, :uw_ca_file
	def initialize
		@api_url = "https://iam-ws.u.washington.edu:7443/group_sws/v2"
		@uw_ca_file = "#{ENV['HOME']}/uwca.crt"
	end
	def make_get_request
		options = {
			use_ssl: true,
			cert: OpenSSL::X509::Certificate.new(@certificate),
			key: OpenSSL::PKey::RSA.new(@key),
			ca_file: @uw_ca_file,
			verify_mode: OpenSSL::SSL::VERIFY_PEER
		}
		Net::HTTP.start(@uri.host, @uri.port, options) do |http|
			request = Net::HTTP::Get.new(@uri.request_uri)
			@response = http.request(request)
		end
		validate_response(@response)
	end
	# This method returns nil if the http request doesn't return a 200. Maybe also support for not-authorized?
	def validate_response(response)
		nil if response.code.to_i != 200
		response.body if response.code.to_i == 200
	end
	def group_exists?(group)
		@uri = URI.parse("#{@api_url}/group/#{group}")
		make_get_request
		if @response.code.to_i == 200
			true
		else
			false
		end
	end
	


	def view_group(group)
		@uri = URI.parse("#{@api_url}/group/#{group}")
		make_get_request
		@doc = Nokogiri::HTML(@response.body)
		{
			title: get_title,
			description: get_description,
			name: get_name,
			regid: get_regid,
			contact: get_contact
		}
	end



	def get_contact
		@doc.xpath('//span[@class="contact"]').text
	end

	def get_title
		@doc.xpath('//span[@class="title"]').text
	end
	def get_description
		@doc.xpath('//span[@class="description"]').text
	end
	def get_name
		@doc.xpath('//span[@class="name"]').text
	end
	def get_regid
		@doc.xpath('//span[@class="regid"]').text
	end



	# def other thing to use
	# http.ssl_timeout
	# It throws TimeoutError exceptions for timeouts
	# http.cert_store to for.... the CA?
	# or maybe http.ca_file
end