require 'csv'

def metros_from_csv
  path_to_csv_file = "#{Rails.root}/config/metros.csv"
  CSV.read(path_to_csv_file, col_sep: '|').map do |raw|
    {
      name: raw.first,
      coordinates: raw.second,
    }
  end
end

::METROS = metros_from_csv
