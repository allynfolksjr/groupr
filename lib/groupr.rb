require 'net/http'
require 'nokogiri'
class Groupr
  attr_accessor :api_url, :certificate, :key, :uw_ca_file
  attr_reader :request
  def initialize
    @api_url = "https://iam-ws.u.washington.edu:7443/group_sws/v2"
    @uw_ca_file = "#{ENV['HOME']}/uwca.crt"
  end

  # This method returns nil if the http request doesn't return a 200. Maybe also support for not-authorized?
  # def validate_response(response)
  # 	nil if get_response_code != 200
  # 	response.body if get_response_code == 200
  # end
  def get_response_code
    @response.code.to_i
  end
  def group_exists?(group)
    @uri = URI.parse("#{@api_url}/group/#{group}")
    make_get_request
    if get_response_code == 200
      true
    else
      false
    end
  end

  ## Membership-related methods: get, get effective, update, delete


  # https://wiki.cac.washington.edu/display/infra/Groups+WebService+Get+Members
  def get_membership
  end

  # https://wiki.cac.washington.edu/display/infra/Groups+WebService+Get+Effective+Members
  def get_effective_membership
  end

  # http://wiki.cac.washington.edu/display/infra/Groups+WebService+Update+Members
  def update_membership
  end

  # http://wiki.cac.washington.edu/display/infra/Groups+WebService+Delete+Members
  def delete_membership
  end

  ## Member-related methods

  # http://wiki.cac.washington.edu/display/infra/Groups+WebService+Get+Member
  def get_member
  end

  # http://wiki.cac.washington.edu/display/infra/Groups+WebService+Get+Effective+Member
  def get_effective_member
  end

  # http://wiki.cac.washington.edu/display/infra/Groups+WebService+Add+Member
  def add_member
  end

  # http://wiki.cac.washington.edu/display/infra/Groups+WebService+Delete+Member
  def delete_member
  end


  ## Group-related methods. View, create, update, delete.

  # https://wiki.cac.washington.edu/display/infra/Groups+WebService+Get+Group
  def view_group(group)
    @uri = URI.parse("#{@api_url}/group/#{group}")
    body = make_get_request
    @doc = Nokogiri::HTML(body)
    {
      title: get_title,
      description: get_description,
      name: get_name,
      regid: get_regid,
      contact: get_contact
    }
  end



  # https://wiki.cac.washington.edu/display/infra/Groups+WebService+Create+Group
  def create_group(group,description=nil)
  	@group = group
  	description.nil? ? @description = group : @description = description 
    @uri = URI.parse("#{@api_url}/group/#{group}")
    make_put_request
    get_response_code == 200 ? true : false
  end

  # https://wiki.cac.washington.edu/display/infra/Groups+WebService+Update+Group
  def update_group
  end

  # https://wiki.cac.washington.edu/display/infra/Groups+WebService+Delete+Group
  def delete_group
  end

  ## Search

  # http://wiki.cac.washington.edu/display/infra/Groups+WebService+Search
  def search
  end

  # http://wiki.cac.washington.edu/display/infra/Groups+WebService+Get+History
  def get_history
  end


  private
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
    @response.body
  end

  def make_put_request
    options = {
      use_ssl: true,
      cert: OpenSSL::X509::Certificate.new(@certificate),
      key: OpenSSL::PKey::RSA.new(@key),
      ca_file: @uw_ca_file,
      verify_mode: OpenSSL::SSL::VERIFY_PEER
    }
    Net::HTTP.start(@uri.host, @uri.port, options) do |http|
      request = Net::HTTP::Put.new(@uri.request_uri)
      request.body = %Q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
  		"http://www.w3.org/TR/xhtml11/DTD/xhtml11/dtd">
		<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
		<head>
 		<meta http-equiv="Content-Type" content="application/xhtml+xml; charset=utf-8"/>
		</head>
		<body>
  			<div class="group">
   			<span class="description">#{@description}</span>
    			<ul class="names"><li class="name">#{@group}</li></ul>
    			<ul class="admins">
        			<li class="admin">nikky</li>
    			</ul>
  			</div>
		</body>
	</html>}
      @response = http.request(request)
    end
    puts "Response is: #{get_response_code}"
    puts "Body is: #{@response.body}"
    @response.body
  end

  def get_response_code
    @response.code.to_i
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

end
