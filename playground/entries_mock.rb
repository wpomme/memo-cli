
def files_grouped_by_dir
  grouped_files = {}
  grouped_by_dir(@entries).keys do |key|
    grouped_files[key] = @entries[key].map{|entry| entry.filename}
  end
  grouped_files
end


repo.files_grouped_by_dir


