# 리눅스 - 기본 개념 정리


### 리눅스 구성 3요소
- 커널 (Kernal)
   - 사용자가 원하는대로 하드웨어를 관리해주는 역할
   - 하드웨어 > 커널이 관리함
   - 리눅스 /유닉스 시스템이 부팅될때 가장먼저 읽혀지는 운영체제의 핵심부분
   - 프로세스 스케쥴링, 메모리관리, i/o 장치관리, 파일관리

- 쉘 (Shell) 
   - 사용자와 커널을 연결해주는 매개체 , 명령어 해석기 역할
   - 사용자가 명령어를 입력 > 해석 > 사용자가 지정한 명령어를 프로그램을 실행하는 인터페이스
   - 운영체제의 가장 바깥에 위치함 

- 디렉토리 (디렉토리 파일 시스템) 
   - 파일을 어떻게 관리할 것인가를 결정하는 역할


## Unix
-  다양한 시스템 사이에서 서로 이식 가능
-  멀티 태스킹과 다중 사용자를 지원하도록 설계됨

- Unix 특징
   - 일반 텍스트 파일
   - 명령행 인터프리터
   - 계층적인 파일 시스템
   - 장치 및 특정한 형식의 프로세스 간 통신을 파일로 취급 

- 유닉스는 판매할때 서버를 같이 판매
- 현재 구입시 초기비용이 비쌈 (but 유지보수 비용은 free)


## CentOS
- 레드햇의 소스코드 오픈버젼
- 5개의 가상콘솔을 지원하고있음 ctrl+alt f1~f5로 변경가능


## Linux Shell
- 리눅스에는 확장자를 기본으로 지원하지않는다

- 스냅샷
   - 복원시점 저장기능

- bash shell 
   - born agin shell 


- CLI
   - 띄어쓰기로 구분하며 대괄호 내용은 있을수도 없을수도있음 
   
   - CLI 창 크기 조절    
      - 컨트롤 '-' 
         - 창크기 줄이기
      - 컨트롤 쉬프트 + 
         - 창 크기 키우기


   - CLI 기본 형태
      ```
      command [option] [argument]
      명령어     옵션     대상
      ``` 
	
- 명령어 도움말 보기   
   - whatis [명령어] / man -f / --help


### tty간 메세지 전송

- write 사용자명 tty# (# : 터미널 넘버) 
   -  메세지 주고받기기능 (root는 그냥 입력해도 가능)
   - ctrl +d로 취소

- wall 메세지내용 
   - 모든 터미널에 메세지 내용을 브로드 캐스팅
   - who -w에서 +인경우 mesg y상태 -인경우 mesg n 상태임을 뜻함

- 루트사용자가 보내는 메세지와 브로드캐스트 메세지는 거부 불가능
   - mesg n 상태여도 받을수밖에없음

### 사용자 관련
- ROOT
   - 리눅스에서의 관리자를 뜻함
   - 관리자 모드로 접속해야하는 경우, root계정으로 접속해야함
   - 루트 사용자는 date 변경 가능함 
      - 시스템이 켜진 동안만 유지

- wheel 그룹 
   - 관리자 권한을 대행하는그룹
   - wheel그룹에 추가된 사용자 외에는 su나 sudo의 명령어 접근제한
   - pam 모듈 설정 및 /etc/sudoers 파일을 수정 필요
   
- 사용자 추가 
   - useradd 사용자명 

- 사용자의 패스워드 설정
   - passwd 사용자명 

- 사용자 전환
   - su - 사용자이름 

### 명령어 사용 시록 
- history
   - 현재 계정의 명령어 사용기록
- !u 
   - u로시작하는 가장 최근에 사용한 명령어 사용

### 명령어 자동완성
   - 탭 두번 입력 시 명령어 자동완성 기능 사용가능
   - Centos의 경우 bash-completion 설치필요


## vi/vim text editor 
- r 
   - 한글자에대해서 대체 입력가능(수정가능)
- R 
   - replace 모드 집입 

- dw  
   - 단어삭제 
   - 스페이스(공백)와 특수문자를 기준으로 단어를 나눔

- set nu 
   - 라인 표시 설정

- set hls is 
   - 단어 찾기에서 하이라이트 설정

- v/ 대문자 v /컨트롤 v
   - 비주얼모드와 비주얼 라인 

- 라인숫자 dd 
   - 아래로 라인숫자만큼 지운다

## 기본 환경변수

- $HOME 
   - 홈디렉토리 경로를 담은 환경변수

- $PATH 
   - 환경 변수들의 경로를 보여주는명령어, ' :  '으로 구분되어있다 
   - 명령어를 입력시 환경변수에 잡혀있는 PATH를 따라가서 해당파일이 실행되는 원리


### 기타

- run 디렉토리 
   - 메모리에 있는 파일들이 왔다갔다하는 경로

- alias 
   - 특정 명령어의 별칭 지정가능 터미널이 켜져있는 동안만 동작함
      - 터미널이 닫히면 저장x
   - .bashrc에 입력하면 영구적으로 설정가능 (설정파일변경)

- .bashrc 
   - 개인 설정파일. alias등을 시스템이 종료되었다 다시켜져도 유지되도록 함

## 경로의 구분
- 절대경로 
   - 무조건 / (루트디렉토리)부터 시작하는 경로
- 상대경로 
   - 현재 내 위치부터 시작하는 경로 

### 디렉토리 이동
- cd ./ or cd . 
   - 현재 디렉토리  
- cd ../ or cd .. 
   - 상위 디렉토리
- cd ~ 
   - 현재사용자의 홈디렉토리로 이동
- cd - 
   - 이전디렉토리로 이동

### 절대경로/상대경로 예제 
- 현재위치가 book/일때 코믹으로 이동하는경우
   - 절대경로
      - cd /bob/comic
   - 상대경로
      - cd ../../bob/comic

- 현위치 /alice 이동위치 book 아래 ant
   - 절대경로  
      - cd alice/book/ant
   - 상대경로
      - cd ./ book/ant
      - cd  book/ant 

## Linux CLI 명령어 

### whoami / who am i 
   - who am i 
      - 최초 접속한 사용자

   - whoami
      - 지금 터미널창에있는 사용자

### wc  
- 기본 형태
   - wc 파일명 

- wc -l 파일명
   -  현재 파일에 존재하는 라인 수
- wc -w 파일명
   - 현재 파일에 존재하는 단어수
- wc -c 
   - 현재 파일의 크기


### grep
- grep -w 
   - 단어 그자체만을 찾음 > 앞뒤로 다른것이 안붙어있는것만 찾음
- egrep 
   - 여러개의 패턴을 찾을때 사용 '( 패턴1|패턴2)' 형태로 주로 사용
   - grep -e 를 사용해서도 가능함 
      - 각 패턴을 입력할때마다 -e 를 옵션으로 입력해줘야함
      >ex) grep -e 'i hate'  -e 'i love' -e 'you love' -e 'you hate' test

- fgrep 
   - 앞이나 뒤에 정규표현식 특수문자가 있는 경우 일반문자 취급함
   - grep에서 패턴에 특수문자를 넣어야하는 경우 \(역슬래시)를 앞에 붙여주면 인식함

- grep에서 사용하는 [] 안의 내용은 오름차순만 인식한다 
   - >ex) a-z A-Z 0-9는 인식 z-a Z-A 9-0은 인식불가(에러발생)
   - [^a] :소문자 a를 제외한 모든 문자


### cp
- 기본 형태
   - cp 복사대상 [생성하고자 하는 파일명] or [생성위치]
- 파일을 복사하는 경우 inode값은 변화한다   

- 복사대상이 다수일경우
   - ex) cp 대상 1 대상2  [디렉토리]

- cp ~centos/f1  ./ 
   - centos 에 있는 f1을 현재위치에 복사

- cp로 디렉토리를 복사하는경우 안에있는 파일이 서로 다른경우 합쳐지게된다

### mv
- 기본 형태 
   - mv 이동 대상 [이동 파일위치]

- 기존 파일의 파일명을 변경하는 경우에도 사용
   - mv 기존파일명 [변경할 파일명]

- mv를 사용해서 옮기는 경우 사용자 소유권이나 inode값이 변하지않는다
- 디렉토리를 옮길때도 -r 옵션이 필요없음

### rm 
-  기본 형태 
   - rm 

### cp,rm,mv에서의 옵션설정
- -i 
   - 덮어쓰기나 삭제에 대해서 대화형태로 진행
- -f 
   - -i 옵션이 있는 경우 대화옵션을 해제 (cp는 안되는 경우있음)
- cp -a  
   - 복사하는파일의의 모든 속성을 가져오면서 복사함
   - centos 8.0에서 안되는 경우있음

### 기타 명령어
- more / less 
   - 현재 터미널의 화면크기에 맞추어서 파일 내용을 출력함
   - more과 less의 차이점 
      - less는 방향키와 페이지 업다운 검색이 가능함

- mkdir -m 
   - 디렉토리를 만들때 권한을 변경해서 생성할수있음

- find
   - 자동적으로 하위디렉토리까지 탐색한다
   - find -type 
      - d
         - 디렉토리 
      - f 
         - 파일
      - l 
         - 심볼릭링크

- locate 
   - db에서 단어를 찾을때 사용하는 명령어

- ls -a
   - 숨김파일 확인용

- tail -f  
   - 파일을 띄워두고 정보가업데이트되는 것을 확인가능

- tail -n +숫자  파일명 
   - 위에서부터 해당열부터 끝까지보여줌 
      - +를 사용하려면 -n생략 불가능

- esc + '.'
   - 이전에 입력한 주소를 그대로 불러옴

- shutdown -h
   - 1분뒤 종료


## 하드링크 / 심볼링크

### 하드링크  
- 원본파일과 이름을 제외한 모든값이 같은 파일
- i-node값이 동일
- 인위적으로는 생성이 안되지만 하위 폴더가 생성될때마다 자동적으로 추가

### 심볼링크 
- 파일이 가지고있는 이름의 경로를 기억한다 
- 상대경로와 절대경로중 어떤것으로 설정하느냐에따라 성질이 바뀐다

- `하드링크나 심볼링크 중 어떤 값을 수정하더라도` <br> `하드링크 파일은 만약 원본파일이 사라지면 원본파일을 대체함`


## 권한
- 권한별 가능 작업

|권한|파일|디렉토리|
|:--|:--:|:--:|
|r|cat, more, less<br>head, tail, wc ,grep<br>문서편집기(vim,gedit)|ls, cp, tar, find|
|w|문서편집기를 이용한 문서수정|생성, 삭제, 이동|
|x| 명령어나 실행이가능한 <br>파일을 실행할수있음|접근권한(cd가 가능)|
      
- 디렉토리에 대한 접근권한이있어야만 읽기나 쓰기가 가능함
- 소유자/루트는 권한상관없이 다 가능함
- 자기가 속해있는 그룹의 소유권을 먼저 받는다
- chmod 에서 대문자X는 심볼릭모드에서만 가능하다

## 프로세스
- 프로세스 
   - 메모리에 올라가서 컴퓨터 cpu에서 실행되는 모든 프로그램을 일컫는 말

- ps tree 
   - 트리형태로 프로세스를 보여줌
- ps -ef 
   - 현재실행중인 모든 프로세스를 보여줌 
   - PID PPID TTY확인가능
- ps aux  
   - 현재 실행중인 모든프로세스를 보여줌 
   - CPU memory 사용량 PID 확인가능

### background & foreground
- 명령어 &
   - 백그라운드에서 명령어 실행

- jobs 
   - 백그라운드 프로세스를 보여줌

- fg %num 
   - num번 백그라운드 프로세스을 멈춤

- sleep n 
   - n초동안 쉘스크립트를  멈춤 

|signalnum | 짧은옵션 | 긴옵션|
|:-:|:-:|:-:|
|1|-hup|-sighup|
|2|-int|-sigint|
|9|kill|-sigkill|
|15|-term|-sigterm (def)|
|18|=cont|-sigcont|
|19|stop|-sigstop|

### PID
- PID
   - 운영체제에서 프로세스를 식별하기위해 프로세스에 부여하는번호
- PPID 
   - 부모프로세서의 PID를 의미 
   - 만약 부모프로세스가 자식프로세스보다 빨리 종료되는경우 자식프로세스의 PPID는 1이된다

- ps -ef 프로세스의 pid와 ppid를 확인할수 있음

- kill -옵션 PID 
   - 프로세스를 정지 종료 제거하는 명령어

- pkill -f 프로세스명(혹은 일부) 
   - 프로세스명을 검색하여 정지시킴 
   - 프로세스의 풀네임을 입력하지않아도 작동

- killall -9 프로세스명
   - 프로세스명을 검색하여 정지시킴 
   - 프로세스의 풀네임을 입력해야만 작동

- pkill -t 터미널 번호  프로세스명
   - pts/0 의 sleep프로세스를 킬

- nice -n nice값 프로세스 
   - -20~19까지 조정가능 
   -  root사용자만 값을 줄일수있고 일반사용자는 증가만가능

- renice nice값 [옵션] pid 
   - 실행중인 프로세스의 nice값 변경
   - root사용자만 값을 줄일수있고 일반사용자는 증가만가능

## 아카이브(Archive)

### 아카이브
-  원래 뜻은 보관소/저장소.
- 리눅스에서의 아카이브 
   - 파일을 묶어서 하나로 만든것. 즉 압축파일

- 아카이브 명령어 기본 형태
   - tar 옵션 아카이브명 

- 아카이브파일은 파일의 권한 경로 등 여러가지값들이 모여있음 
   - 원래 파일보다 크기가 커질수있다

- 아카이브 파일 형식
   - gzip >  bzip2   > xz  
      - 갈수록 속도는 감소하고 압축률은 증가함   

- 아카이브는 무조건 상대경로로 만들어야 함 
   - 절대경로로 설정하면 tar 안에 절대경로와 동일한 하위디렉토리를 만듬      

### 압축형식별 명령어

|압축형식|명령어|
|:-:|:-:|
|tar| tar cvf file.tar [argument(대상)]|
|gzip|tar zcvf file.tar.gz [argument(대상)]|
|bzip2|tar jcvf file tar.bz2 [argument]|
|xz|tar Jcvf file.tar.xz [argument]|

### tar가 아닌 명령어로 압축 해제

|명령어를 이용한 압축|해제방법|해제방법2|
|:-:|:-:|:-:|
|gzip file|-d옵션|gunzip|
|bzip2 file-d|옵션|gunzip|
|xz file|-d옵션|gunzip|

- 디렉토리 압축 불가능(파일만가능)
- 압축을 하는 순간 원본파일이 사라짐
- 압축을 해제하는 순간 기존 압축 파일 사라짐


- *주의* 아카이브의 압축을 풀때는 현재경로에서 시작함 

ex ) 
```bash
#root에 dir1,2를 만들고 dir1에는 01~20의 파일을 생성한뒤 dir2에 아카이브생성
mkdir dir{1..2} touch dir1{01..20}
dir1/{01..20}    tar cvf dir2/num.tar dir/{01..20}

#1.root에서 압축을 푸는 경우
[root@localhost ~]#tar xvf dir2/num.tar   
#>  루트에 dir1이 덮어쓰기됨 
#(만약 압축을 풀기전 dir1이 사라져있다면 새로 생김)

#2.dir2에서 압축을 푸는경우
[root@localhost dir2]#tar xvf num.tar
# > dir2 내에 dir1이 생기고 그안에 압축되었던 파일이 풀림
```

- tar xf 아카이브파일 -C 다른경로 
   - 다른경로에 압축을 풀고싶을경우 사용

