require 'sinatra'
require 'sinatra/reloader'


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
