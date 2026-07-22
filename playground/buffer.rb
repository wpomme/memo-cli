# frozen_string_literal: true

mock_seeds = seeds.map do |seed|
  content = Memo::Repository.read(seed)
  filename = seed.filename.upcase
  val_name = "TEST_#{filename}_FILE_CONTENT"
  label = "#{filename}_FILE"
  heredoc = ["#{val_name} = <<~#{label}"] + content + [label] + ["\n"]
  {
    mock_seed: { dir: seed.dir, filename: seed.filename, content: val_name },
    heredoc: heredoc
  }
end

mock_seeds.map { |seed| seed[:mock_seed] }

File.open("test/test_mock_seeds.rb", "w") do |file|
  mock_seeds.each do |seed|
    file.puts(seed[:heredoc])
  end
end
