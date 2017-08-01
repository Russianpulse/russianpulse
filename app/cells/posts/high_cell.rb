module Posts
  # Post widget with picture
  class HighCell < BaseCell
    def show
      @post = model
      render
    end
  end
end
