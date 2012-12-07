require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Groupr" do

	before do
		@group = Groupr.new
		# @group.certificate = File.read("#{ENV['HOME']}/nikky_cac_washington_edu.cert")
		# @group.key = File.read("#{ENV['HOME']}/nikky_cac_washington_edu.key")
	end

	it "Checks for network connectivity"
	it "Should allow you to specify a custom Service API" do
		@group.respond_to?(:api_url).should eq true
	end
	it "Should allow you to specify your certificate" do
		@group.respond_to?(:certificate).should eq true
	end
	it "Should Allow you to specify your key" do
		@group.respond_to?(:key).should eq true
	end

	context "#group_exists?" do
		it "Should tell you that the uw_employees group exists" do
			@group.should_receive(:make_get_request).and_return(nil)
			@group.should_receive(:get_response_code).and_return(200)
			@group.group_exists?("u_nikky_git").should be_true
		end
		it "Should tell you that the a_team group does not exist" do
			@group.should_receive(:make_get_request).and_return(nil)
			@group.should_receive(:get_response_code).and_return(404)
			@group.group_exists?("a_team").should be_false
		end
	end

	context "#view_group" do
		before do
			@group.should_receive(:make_get_request).and_return(File.open('view_group.html'))
			@results = @group.view_group("u_nikky_git")
		end
		it "Should tell you the group name" do
			@results[:name].should eq "u_nikky_git"
		end
		it "Should tell you the group description" do
			@results[:description].should_not == ""
		end
		it "Should tell you the group contact" do
			@results[:contact].should eq "nikky"
		end
		it "Should tell you the group title" do
			@results[:title].should eq "nikky git"
		end
	end


	context "#get_members" do
		it "Gets the members of a group"
	end

	context "#add_member" do
		it "Adds a member to a group"
	end

	context "#remove_member" do
		it "Removes a member from a group"
	end
end
