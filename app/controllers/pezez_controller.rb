
class PezezController < ApplicationController
  
  def index
  end
  
  def new
    @pez = Pez.new
  end
  
end