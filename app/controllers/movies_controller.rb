class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    puts "SHOW CALLED"
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    puts "INDEX CALLED"
    puts ""
    puts "PUTS STUFF"
    puts params #debugging info
    
    if params[:commit] == "Refresh" && params[:ratings].nil?
      session.clear #if the user presses the "Refresh" button with no ratings checked, reset the session and remove all filters
    end
    
    if params[:sort_by].nil? && params[:ratings].nil? && (!session[:sort_by].nil? || !session[:ratings].nil?)
      puts "REDIRECTING TO STORED SESSION"
      flash.keep
      redirect_to movies_path(:sort_by=>session[:sort_by], :ratings=>session[:ratings])
      session.clear
    else
      session[:sort_by] = params[:sort_by]
      session[:ratings] = params[:ratings]
    end
    
    @all_ratings = Movie.all_ratings
    if !params.nil? && !params[:ratings].nil?
      @selected_ratings = params[:ratings].keys
    else
      @selected_ratings = @all_ratings
    end
    puts @selected_ratings
    @movies = Movie.where(rating: @selected_ratings).order(params[:sort_by])
    @sorted_column = params[:sort_by]
  end

  def new
    puts "NEW CALLED"
    # default: render 'new' template
  end

  def create
    puts "CREATE CALLED"
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    puts "EDIT CALLED"
    @movie = Movie.find params[:id]
  end

  def update
    puts "UPDATE CALLED"
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    puts "DESTROY CALLED"
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
