# GCP Cloud Console 관련내용 정리

## 로컬 PC에서 SSH를 통해서 GCP VM의 외부주소로 접속하는 방법 

### LOCAL PC 
- cmd 혹은 powershell 에서 ssh 키를 생성할 위치로 이동
```
cd .ssh
```

-다음 명령어를 통해 ssh 키 생성 
```
ssh-keygen -t rsa -f .ssh/GCP_KEY -c [ GCP에서 접속중인 GMAIL 계정 ]
```
`* 옵션은 전부 엔터로 처리`

### GCP Console
- Compute Engine의 메타데이터로 이동
- 생성된 키중 공개키(.pub) 를 GCP 메타데이터 > SSH키 혹은 VM 생성 후에 메타데이터에 입력 
- 방화벽 규칙에서 22포트 연결을 허용 (0.0.0.0/0 혹은 주소 범위를 지정)

### mobaxterm 접속 방법
- session  > Advanced SSH settings의 Use Private Key 체크 
  - 개인키 파일 선택 후 접속 확인.

### putty 접속 방법
- puttygen 으로 개인키 파일 불러온뒤 save private key 로 ppk 파일 생성 `genrate아님`
- 만들어진 ppk 파일을 Connection > Auth > Credentials 에서 private key로 불러온뒤 접속확인.

<br><br>

## GCP 인스턴스 일정 적용시 권한 부여 방법

### GCP 인스턴스 일정 사용에 필요한 권한
- Compute Engine 서비스 에이전트
  - `compute.instances.start`
  - `compute.instances.stop`

- 사용자 또는 서비스 계정 필수 역할
  - `compute.resourcePolicies.create` ( 인스턴스 일정 만들기 )
  - `compute.resourcePolicies.list` ( 인스턴스 일정 나열 )
  - `compute.resourcePolicies.get` ( 인스턴스 일정 설명 )
  - `compute.resourcePolicies.delete` ( 인스턴스 일정 삭제 )

  - 새 VM에 인스턴스 일정 연결
    - `compute.instances.create`
    - `compute.resourcePolicies.use`
    - `compute.instances.addResourcePolicies`
  
  - 기존 VM에 인스턴스 일정 연결
    - `compute.resourcePolicies.use`
    - `compute.instances.addResourcePolicies`
  
  - VM에서 인스턴스 일정을 삭제
    - `compute.resourcePolicies.use`
    - `compute.instances.removeResourcePolicies`


> 해당 권한들은 모두 `Compute 인스턴스 관리자(v1)` 역할에 포함되어있으므로 해당 역할을 부여.

- IAM > `Google 제공 역할 부여 포함` 체크 하여 모든 사용자 확인

- 이름 항목이 `Compute Engine Service Agent`로 된 사용자 찾기

- `Compute Engine Service Agent` 에 `Compute 인스턴스 관리자(v1)` 역할을 추가 

- 인스턴스 일정 생성 후 인스턴스 추가하여 정상작동 확인.

<br><br>

## 고정 외부 IP 관련 사항 

- VM 등에 고정된 IP를 부여한 뒤 삭제하면 고정된 IP는 같이 삭제되지않음.

- 고정 외부 IP를 다른 리소스에 할당하지 않고 그대로 둔 경우 비용이 많이 발생 

  - 확인후에 할당 혹은 삭제 할것.

<br><br>

## GCP 재부팅시 SSH 접속불가한 경우
* Ubuntu 기준으로 작성 `(CentOS에서는 발생한적 없음...)`

* DNS정보가 누락되어 DHCP 서버에 연결하지 못하여 IP가 할당되지 않아서 발생하는 현상.

* 직렬콘솔로 연결하여 작업 진행


### 해결방법
#### 1. NIC 상태 확인
* Down 상태 or 할당되지않은 NIC가 있는지 확인
 ```
ip ad
```
#### 2. Routing 상태 확인
해당 Subnet의 Default Gateway에 연결되어있는지 확인
```
ip route
```
#### 3. DHCP On & MAC Address 확인
>vi /etc/netplan/50-cloud-init.yaml 
```yaml
network:
  ethernets:
    ens:
      dhcp4: true
      match:
        macaddress: xx:xx:xx:xx...
      set-name: ens4
  version: 2  
```
* 해당 정보와 `ip ad`로 조회한 값이 동일하지 확인
<br>

#### 4. DNS 확인
* GCP DNS가 제대로 설정되어있는지 확인. 

* `대부분 이 부분에서 문제가 발생하였음`

> vi /etc/resolv.conf
```
# Generated by NetworkManager
search asia-northeast3-c.c.[프로젝트명].internal c.[프로젝트명].internal google.internal
nameserver 169.254.169.254
```
* 정상적으로 적혀있지 않으면 같은 서브넷에 있는 VM등을 참고하여 재설정
<br>

#### 5.DNS 재설정 후 DHCP서버에 ip할당 요청
```
dhclient
```

#### 6. NIC 및 Route 상태 확인
```bash
ip ad
ip route 
ping google.com #인터넷 가능한경우 사용
```
<br>

## OS 별 VM 시작 스크립트
### CentOS7
- password 변경 
- SELINUX , firewalld off 
- SSH 설정변경 : root 로그인 허용, Publickey 사용 가능
- 기본 패키지 설치 : git curl wget bash-completion

### Ubuntu 20.04
- password 변경
- SSH 설정변경 : root 로그인 허용, Publickey 사용 가능
- 기본 패키지 설치 : git

#### CentOS 7	
```bash
sudo -i << EOF
echo "root:welcome1" | /sbin/chpasswd
echo "wocheon07:welcome1" | /sbin/chpasswd
sed -i 's/=enforcing/=disabled/g' /etc/selinux/config ; setenforce 0
systemctl disable firewalld --now
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd
yum install -y git curl wget ansible bash-completion
echo "$(hostname -i) $(hostname)" >> /etc/hosts
EOF
```

##### Ubuntu
```bash
sudo -i << EOF
echo "root:welcome1" | /usr/sbin/chpasswd
echo "wocheon07:welcome1" | /usr/sbin/chpasswd
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd
apt-get install -y git
EOF
```

## Cloud Shell로 현재 VM 목록 출력 
```
gcloud compute instances list --format="csv[separator='\t'](name,zone,machineType,INTERNAL_IP,EXTERNAL_IP,status)" --sort-by zone --filter="status=RUNNING"
```

