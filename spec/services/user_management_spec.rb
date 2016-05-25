require 'spec_helper'
describe UserManagement do
  describe 'make_site_admin' do
    context 'a valid user exists' do
      let(:user) { User.create!(email: 'test@email.com', password: 'testpassword') }
      subject {  UserManagement.make_site_admin(user.email) }
      it 'should make the user the site admin' do
        expect { subject }.to change { user.roles.count }.by(1)
        expect(user.roles.pluck(:resource_type)).to include 'Spotlight::Site'
      end
    end
    context 'no matching user exists' do
      subject { UserManagement.make_site_admin('notvalid') }
      it 'should not error' do
        expect { subject }.not_to raise_error
      end
      it 'should print an error to stdout' do
        expect { subject }.to output("User with email notvalid could not be found!\n").to_stdout
      end
    end
  end
end
