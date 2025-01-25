require "csv"

class MemoApp
  def initialize
    @current_directory_files = Dir.glob("*.csv")
  end

  def get_file_name
    puts "ファイル名を入力してください (拡張子を除く):"
    gets.chomp + ".csv"
  end

  def display_existing_files
    puts "現在のディレクトリにあるCSVファイル一覧:"
    if @current_directory_files.empty?
      puts "CSVファイルが存在しません。"
      exit
    else
      @current_directory_files.each_with_index do |file, index|
        puts "#{index + 1}: #{file}"
      end
    end
  end

  def write_new_memo
    file_name = get_file_name
    puts "新しいメモの内容を入力してください（終了するにはCtrl+Dを押してください）:"
    content = $stdin.read

    CSV.open(file_name, "w") do |csv|
      csv << [content]
    end

    puts "新規メモが作成されました: #{file_name}"
  end

  def edit_existing_memo
    display_existing_files
    file_name = get_file_name

    if File.exist?(file_name)
      puts "現在のメモ内容:"
      rows = CSV.read(file_name).map(&:join)
      rows.each_with_index do |row|
        puts "#{row}"
      end

      puts "追記のメモの内容を入力してください（終了するにはCtrl+Dを押してください）:"
      content = $stdin.read

      CSV.open(file_name, "a") do |csv|
        csv << [content]
      end

      puts "メモが更新されました: #{file_name}"
    else
      puts "指定されたファイルは存在しません: #{file_name}"
      exit
    end
  end

  def run
    loop do
      puts "1 → 新規でメモを作成する / 2 → 既存のメモを編集する"
      memo_type = gets.to_i

      case memo_type
      when 1
        write_new_memo
        break
      when 2
        edit_existing_memo
        break
      else
        puts "1か2を入力してください。"
      end
    end
  end
end

# アプリケーションの実行
memo_app = MemoApp.new
memo_app.run
