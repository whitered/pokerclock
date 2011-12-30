class ClocksController < ApplicationController
  before_filter :set_locale

  def show
    render :show, layout: false
  end

private

  def set_locale
    I18n.locale = params[:lang] || :en
  end

end
