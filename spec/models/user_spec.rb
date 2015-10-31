require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../shared_examples')

describe User, type: :model do
  include_examples 'there are users with and without avatars'
  let(:user) { FactoryGirl.build :user }

  specify { expect(user.attachments).to all be_a_kind_of Attachment }

  describe '#local_avatar_attachment' do
    subject { user.local_avatar_attachment }

    context 'WHEN user has an avatar' do
      let(:user) { user_with_avatar }
      it { is_expected.to be_a_kind_of Attachment }
    end

    context 'WHEN user has no avatar' do
      let(:user) { user_without_avatar }
      it { is_expected.to be_blank }
    end
  end

  describe '#local_avatar_attachment=' do
    context 'WHEN the uploaded file is not an image' do
      subject { lambda { user.local_avatar_attachment = bogus_avatar_file } }
      let(:rescue_block) { lambda { begin; subject; rescue; false end } }
      it { is_expected.to raise_error }
      specify { expect(rescue_block).not_to change(user, :local_avatar_attachment) }
    end

    context 'WHEN the uploaded file is a good image' do
      subject { lambda { user.local_avatar_attachment = avatar_file } }
      it { is_expected.not_to raise_error }
      specify { is_expected.to change(user, :local_avatar_attachment) }
    end
  end
end
