class NotesController < ApplicationController
  def index
    @notes = Note.all
  end

  def show
    @notebook = Notebook.find(params[:notebook_id])
    @note = Note.find(params[:id])
  end

  def today
    @html = ""
    @contents = Array.new
    @dates_array = Array.new
    @dates_array.push(Date.today)
    @dates_array.push(Date.today - 1)
    @dates_array.push(Date.today - 2)
    @dates_array.push(Date.today - 3)
    @dates_array.push(Date.today - 7)
    @dates_array.push(Date.today - 14)
    @dates_array.push(Date.today - 31)
    @dates_array.each do |date|
      if params[:id]
        @notes = Note.where("updated = \"#{date}\"").where("notebook_id = \"#{params[:id]}\"")
      else
        @notes = Note.where("updated = \"#{date}\"")
      end
      if @notes
        @notes.each do |note|
          p note.title
          @contents.push(note)
        end
      end
    end
  end
end
