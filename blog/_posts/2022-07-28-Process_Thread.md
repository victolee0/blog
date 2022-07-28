---
title: 프로세스와 스레드
summary: 프로세스와 스레드 및 관련 개념
tags:
 - OS
 - Computer Science
date: 2022-07-28
---

# Program

 - 수행할 작업에 대한 명령어들의 집합
 - 메모리에 올라가지 않고 보조기억장치(HDD, SSD , ... )에 저장되어 있는 상태
 
# Process

운영체제에게 시스템 자원을 할당받는 작업의 단위

-- 시스템자원 : CPU, 메모리 등
## 프로세스의 상태
![enter image description here](https://upload.wikimedia.org/wikipedia/commons/thumb/8/83/Process_states.svg/1024px-Process_states.svg.png)
- 생성(create) : 프로세스가 생성되는 중이다
- 실행(running) : 프로세스가 CPU를 차지하여 명령어들이 실행되고 있다
- 준비(ready) : 프로세스가 CPU를 사용하고 있지는 않지만 언제든 사용할 수 있는 상태로, CPU가 할당되기를 기다리고 있다. 일반적으로 준비 상태의 프로세스 중 우선 순위가 높은 프로세스가 CPU를 할당받는다.
- 대기(waiting) : 보류(block)라고 부르기도 한다. 프로세스가 입출력 완료, 신호 수신 등 어떤 사건을 기다리고 있는 상태를 말한다.
- 종료(terminated) : 프로세스의 실행이 종료되었다.

## Process Control Block
 ![](https://binaryterms.com/wp-content/uploads/2019/08/Process-Control-Block.jpg)
- Process Control Block(PCB)
- 운영체제에서 프로세스에 대한 모든 정보를 저장하기위해 사용하는 자료구조
- 프로세스가 생성될 때 OS는 PCB를 만든다.

구성은 다음과 같다
- Process-ID : 프로세스 식별자
- Process state : 위에서 언급한 프로세스 상태
- Process Priority : 프로세스 스케줄링을 위한 우선순위. 
-- 숫자로 된 값이며 값이 작을수록 우선순위 높음
-- 우선 순위는 OS 스스로 결정할 수 있고, 유저가 직접 정할 수 있음
-- 프로세스 생성 시에 우선순위가 배정되며, 변화 가능 
- Accounting Information : 프로세스 계정 정보, 프로세스가 사용한 자원에 대한 설명을 담고 있음 (CPU 사용 시간, 실 사용 시간, 연결 시간 등)
- Program Counter: 다음에 실행될 프로그램이나 코드에 대한 포인터. 다음에 실행될 명령어의 주소를 포함
- List of Open Files : 프로그램이 실행 중 필요한 파일에 대한 정보를 담고 있음.
- Process I/O status Information : 프로세스 실행 도중 할당될 I/O 장치의 리스트
- CPU Register: interrupt의 발생이나 context switch가 일어날 때 레지스터에 임시적인 값과 정보를 보관하는데 사용. 이 정보는 프로세스가 다시 실행할 때 제대로 실행될 수 있도록 하는데 사용됨
- PCB Pointer: ready 상태인 다음 PCB의 주소를 갖고 있음
- Memory Management Information : 프로세스의 메모리 공간 정보, segmentation table, page table 등의 정보 보관
-- segmantation과 paging은 가상 메모리를 다루는 방법들

## 프로세스의 특징
- 프로세스마다 독립적인 메모리를 할당받는다
- 각 프로세스는 메모리를 공유할 수 없다
--> 다른 프로세스에 접근할 수 없다
--> 다른 프로세스의 자원이 필요하다면 프로세스 간 통신(Inter-Process Communication)을 사용해야 한다
- 프로세스는 최소 하나의 스레드(메인 스레드)를 갖고 있다.
- 하나의 프로그램이 여러 프로세스를 실행할 수 있다.
--> 멀티 프로세스
	- 장점
		- 독립된 구조로 여러 프로세스중 하나가 잘못되어도 프로그램이 동작
	- 단점
		- Context Switching 과정에서 캐시 메모리 초기화와 같은 무거운 작업이 자주 일어나며 오버헤드가 발생
		- 각 프로세스 간 변수 공유 불가

## Memory Layout in Program
![enter image description here](https://miro.medium.com/max/1122/1*CtL4OiSQFvSrK8mIOkb5zQ.png)

### Stack
- OS 커널 아래에 위치
- 프로그램에서 함수 호출에 필요한 데이터를 저장
-- 지역변수, 반환 주소 등

### Heap
- C언어에서 malloc / new , free / delete에 의해 관리된다
- 일반적으로 동적 메모리 할당이 발생
- Heap과 Stack은 같은 공간을 공유하는데, heap은 낮은 주소부터 Stack은 높은 주소부터 할당된다. 이때 각 영역이 침범한다면 각각 heap overflow, stack overflow가 발생했다고 한다

### BSS (Block Started by Symbol)
초기화되지 않은 변수가 저장되며, 여기에 담긴 변수는 프로그램이 시작하기 전에 커널에 의해 0으로 초기화된다.

### Data
초기화된 변수가 저장되며
read-only space, read-write space로 나뉜다.

### Text
기계어 명령어가 저장되며 read-only space이다

# Thread

- CPU가 할당받은 자원을 이용하는 실행의 단위
- 프로세스 내에서 할당받은 자원으로 작업을 수행

## 스레드의 특징

- 스레드는 프로세스 내에서 Stack 영역만 따로 할당받고 Code, Data, Heap 영역은 공유한다
--> 자원이나 주소 공간 등을 공유한다
- 한 스레드가 자원을 변경하면 다른 스레드에서 변한 결과를 즉시 볼 수 있다.


## Multi Thread
프로그램을 여러 스레드로 구성하고 각 스레드가 작업을 처리
- 장점
	- 시스템 자원 소모 감소
		- 프로세스를 생성하면서 자원을 할당하는 시스템 콜이 줄어들어 효율적으로 자원을 관리할 수 있다
	- 스레드 간 자원 공유
	- 처리 비용 감소
		- 작업량이 적기 때문에 빠른 Context Switching 가능
		- 데이터를 주고 받는 것이 간단해지기 때문

- 단점
	 - 디버깅이 까다로움
	 - 동기화 문제 발생 (자원 공유의 문제)
	 - 하나의 스레드에 문제가 발생하면 전체 프로세스가 영향을 받음
	 - 단일 프로세스 시스템의 경우 효과를 기대하기 어려움
	 
### Thread safe
멀티 스레드 프로그래밍에서 함수, 변수, 객체가 여러 스레드로부터 동시에 접근이 이루어져도 프로그램의 실행에 문제가 없음을 의미

구현방법
- Re-entrancy : 어떤 함수가 스레드에 의해 호출되어 실행 중일 때, 다른 스레드가 그 함수를 호출해도 결과가 올바르게 전달되어야 함
- Mutual exclusion : 공유 자원을 꼭 사용해야 할 경우 해당 자원의 접근을 세마포어 등의 락으로 통제
	- 임계 영역(Critical Section) : 공유 데이터에 접근하는 프로그램 코드 블록
	- 뮤텍스(Mutex) : 공유 불가능한 자원의 동시 사용을 피하기 위해 사용하는 알고리즘
		- 임계 구역을 가진 스레드의 실행 시간이 겹치지 않게 실행하도록 함
		- key 기반 방식으로, key에 해당하는 객체를 소유한 스레드만이 공유 자원에 접근 가능 
	
	- 세마포어(Semaphore) : 공유된 자원의 데이터 
		- 자원을 사용하고 있는 스레드의 수가 접근 가능한 최대 허용치보다 커지면 자원에 접근을 제한하는 방법
		- Mutex는 binary Semaphore라고 볼 수 있다
- Thread-local storage : 공유 자원의 사용을 최대한 줄여 각각의 스레드에서만 접근 가능한 저장소들을 사용하여 동시 접근을 막는다
- Atomic operations : 공유 자원에 접근할 때 원자 연산을 이용하거나 원자적으로 정의된 접근 방법을 사용함으로써 상호 배제를 구현할 수 있다.
	- 원자연산 : 성공적으로 연산을 마칠 수 없으면 실행하지 않는 연산 (연산의 결과가 성공 or 미실행)


# Context Switching
![enter image description here](https://forum.huawei.com/enterprise/en/data/attachment/forum/202101/02/160556hoofofzgif3y2flf.png?What-is-Context-Switching-1.png)
- 하나의 프로세스를 실행하고 있는 상태에서 다른 프로세스를 실행해야 할 때, 기존 프로세스의 상태나 레지스터 값(Context)을 저장하고 새로운 프로세스의 상태나 레지스터 값을 교체하는 작업

 - CPU는 하나의 프로세스 정보만 기억할 수 있다
 - 때문에 다른 프로세스를 실행하기 위해서는 기존 프로세스의 상태, 레지스터 값을 PCB에 저장해야 한다
 - 과정은 다음과 같다.
	1. Interrupt/시스템 콜에 의해 context switching 요구
	2. User Mode에서 Kernel Mode로 변경
	3. 기존 프로세스의 상태를 PCB(1)에 저장
	4. 실행할 프로세스의 상태를 PCB(2)에서 CPU로 불러옴
	5. Kernel Mode에서 User Mode로 변경

- Interrupt가 발생하는 상황은 다음과 같다
	- CPU 사용 할당 시간 소모
	- 입출력을 위해 대기
	- 프로세스의 상태 변화
		- running -> ready
		- ready -> running
		- running -> waiting

# reference
https://boostdevs.gitbook.io/ai-tech-interview
https://brunch.co.kr/@babosamo/100
https://velog.io/@chappi/OS%EB%8A%94-%ED%95%A0%EA%BB%80%EB%8D%B0-%ED%95%B5%EC%8B%AC%EB%A7%8C-%ED%95%A9%EB%8B%88%EB%8B%A4.-2%ED%8E%B8-%ED%94%84%EB%A1%9C%EC%84%B8%EC%8A%A4%EC%99%80-%ED%94%84%EB%A1%9C%EA%B7%B8%EB%9E%A8