class MainsController < ApplicationController

  helper_method :timeline
  require 'twitter'

  def client_new
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV["TWITTER_CONSUMER_KEY"]
      config.consumer_secret = ENV["TWITTER_CONSUMER_SECRET"]
      config.access_token = session[:oauth_token]
      config.access_token_secret = session[:oauth_token_secret]
    end

    @user = client.user
    client.home_timeline(:count => 200).each do |tweet|
      @array = Array.new
      @total_array = Array.new
      @tweets = client.home_timeline(include_entities: true)
      text = tweet.full_text
      fav = tweet.favorite_count
      rt = tweet.retweet_count
      @weight = fav + rt * 1.5
      @array = [text, fav, rt, @weight]
      p @array
    end
  end

  # GET /mains
  # GET /mains.json
  def index
    @mains = Main.all
  end

  # GET /mains/1
  # GET /mains/1.json
  def show
  end

  # GET /mains/new
  def new
    @main = Main.new
  end

  # GET /mains/1/edit
  def edit
  end

  # POST /mains
  # POST /mains.json
  def create
    @main = Main.new(main_params)

    respond_to do |format|
      if @main.save
        format.html { redirect_to @main, notice: 'Main was successfully created.' }
        format.json { render :show, status: :created, location: @main }
      else
        format.html { render :new }
        format.json { render json: @main.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mains/1
  # PATCH/PUT /mains/1.json
  def update
    respond_to do |format|
      if @main.update(main_params)
        format.html { redirect_to @main, notice: 'Main was successfully updated.' }
        format.json { render :show, status: :ok, location: @main }
      else
        format.html { render :edit }
        format.json { render json: @main.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mains/1
  # DELETE /mains/1.json
  def destroy
    @main.destroy
    respond_to do |format|
      format.html { redirect_to mains_url, notice: 'Main was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_main
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def main_params
      params.fetch(:main, {})
    end
end
