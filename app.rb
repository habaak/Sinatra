require 'sinatra'
require 'sinatra/reloader'
require 'rest-client'
require 'json'
require 'httparty'
require 'nokogiri'
require 'uri'
require 'date'
require 'csv'

before do 
    p "************************"
    p params
    p request.path_info
    p request.fullpath
    p "************************"
end

get '/' do
  'Hello world!'
end

get '/htmlfile' do
    send_file 'views/html.html'
end

get '/htmltag' do
    '<h1>html태그를 보낼 수 있습니다.</h1>
    <ul>
        <li>1</li>
        <li>22</li>
        <li>333</li>
        <li>4444</li>
    </ul>
    '
end

get '/welcome/:name' do 
    "#{params[:name]}님 안녕하세요"
end

get '/cube/:res' do
    
    "<h1>""#{params[:res].to_i**3}""</h1>"
end

get '/erbfile' do
    @name = "joonhabaak"
    #erb 렌더링
    erb :erbfile
end

get '/lunch-array' do
    # 1. 점심메뉴들이 담긴 lunch 배열 만들기
    lunch = ["백종원", "국수", "버거킹", "20층"]
    @menu = lunch.sample.to_s
    erb :lunchfile
end

get '/lunch-hash' do
    lunch = ["백종원", "국수", "버거킹", "20층"]
    
    lunch_img = {
        "백종원"=>"http://pds.joins.com/news/component/htmlphoto_mmdata/201601/27/htm_201601279134262048.jpg",
        "국수"=>"http://t1.daumcdn.net/thumb/C230x172/?fname=http%3A%2F%2Fm1.daumcdn.net%2Fcfile62%2Fattach%2F21736C4F557E01781CB907",
        "버거킹"=>"http://www.burgerking.co.kr/Content/menu/image/main/burger_bulgogiwhopper.jpg",
        "20층"=>"http://ch.kimhyunjung.kr/web/product/extra/big/201803/493_shop1_549456.jpg"
    }
    
    @menu = lunch.sample
    @img = lunch_img[@menu]
    erb :lunchhash
end

get '/randomgame/:name' do
    
    datas = ["대학일기", "유미의세포들", "죽음에관하여", "마음의소리", "조의영역"]
    data_imgs = {
        "대학일기"=>"http://wtimg.webtooninsight.co.kr/webtoonthumbnail/wi_131115162545570996.jpg",
        "유미의세포들"=>"data:image/jpeg;base64,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",
        "죽음에관하여"=>"http://img.insight.co.kr/static/2018/02/01/700/g23r8kxt63wwvd3057r9.jpg",
        "마음의소리"=>"http://cfile29.uf.tistory.com/image/12604D4C50EF6A7A2627EE",
        "조의영역"=>"http://fimg2.pann.com/new/download.jsp?FileID=24392183"
    }
    data_msg ={
        "대학일기"=>"학점은 개나 줘버린게 똑같아요~~~~",
        "유미의세포들"=>"머리 속에 X만 찼군요!",
        "죽음에관하여"=>"올~~~ 분위기 있다",
        "마음의소리"=>"당신은 삶 그 자체가 웹툰",
        "조의영역"=>"인면어 같다는 말 들어본적 솔직히 있죠ㅋㅋㅋㅋㅋㅋ??"
    }
    @name = params[:name]
    @selected = datas.sample
    @img = data_imgs[@selected]
    @text = data_msg[@selected]
    
    erb :randomgame
end

get '/lotto-sample' do
    @lotto = (1..45).to_a.sample(6).sort
    url = "http://www.nlotto.co.kr/common.do?method=getLottoNumber&drwNo=809"
    #RestClient.get(url,)
    #RestClient.post(url)
    #res = RestClient.get(url)
    @lotto_winner = []
    @lotto_info = RestClient.get(url)
    @lotto_hash = JSON.parse(@lotto_info)
    @lotto_hash.each do |k,v|
        if k.include?('drwtNo')
            #배열에 저장
            @lotto_winner << v
        end
    end
    @the_nums = (@lotto_winner & @lotto).length
    @bonus = @lotto_hash["bunsNo"]
#case
    @grade = 
    case [@the_nums, @lotto.include?(@bonus)]
        when [6, false] then "1등"
        when [5, true] then "2등"
        when [5, false] then "3등"
        when [4, false] then "4등"
        when [3, false] then "5등"
        else "꽝!"
    end
#if
    # if(@the_nums==6)
    #     @grade="1등"
    # elsif(@the_nums == 5 && @lotto.include?(@bonus))
    #     @grade="2등"
    # elsif(@the_nums == 5 )
    #     @grade="3등"
    # elsif(@the_nums == 4 )
    #     @grade="4등"
    # elsif(@the_nums == 3 )
    #     @grade="5등"
    # else
    #     @grade="꽝"
        
    erb :sample
end

get '/form' do
    erb :form
end

get '/search' do
    @keyword = params[:keyword]
    url = 'https://search.naver.com/search.naver?query='
    @encodeName = URI.encode(@keyword)
    # erb
    redirect to (url + @encodeName)
end

get '/opgg' do
    erb :opgg
end

get '/opggresult' do
    url = 'http://www.op.gg/summoner/userName='
    @userName = @params[:userName]
    @encodeName = URI.encode(@userName)
    @res = HTTParty.get(url+@encodeName)
    @doc = Nokogiri::HTML(@res.body)
    
    @win = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.wins").text
    @lose = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierInfo > span.WinLose > span.losses").text
    @rank = @doc.css("#SummonerLayoutContent > div.tabItem.Content.SummonerLayoutContent.summonerLayout-summary > div.SideContent > div.TierBox.Box > div.SummonerRatingMedium > div.TierRankInfo > div.TierRank > span").text
   
    #File.open('파일','옵션') do |f|
    File.open('opgg.txt','a+') do |f|
        f.write("#{@encodeName} : #{@win},#{@lose},#{@rank}\n")
    end
   
    CSV.open('opgg.csv','a+') do |c|
        c << [@userName,@win,@lose,@rank]
    end
    erb :opggresult
end