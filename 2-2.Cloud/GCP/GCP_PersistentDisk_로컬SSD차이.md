## GCP Persistent Disk & Local SSD

---

### **1. Persistent Disk (PD)**

#### **특징**
- **네트워크 기반 스토리지**:
  Persistent Disk는 네트워크를 통해 VM에 연결됩니다. 이는 데이터를 Google Cloud의 스토리지 네트워크에 저장하여 안정성과 내구성을 보장합니다.
  
- **높은 내구성**:
  Google의 데이터 복제 메커니즘을 사용해 데이터를 여러 물리적 위치에 복제하므로 데이터 손실 위험이 낮습니다.

- **유연한 크기 및 확장**:
  디스크 크기를 동적으로 조정할 수 있으며, VM이 실행 중이어도 크기를 확장 가능합니다.

- **다양한 유형**:
  - **표준(PD-Standard)**: 비용 효율적이며 높은 처리량에 적합.
  - **고성능(PD-SSD)**: 낮은 지연시간과 높은 IOPS가 요구되는 워크로드에 적합.
  - **균형형(Balanced PD-SSD)**: 비용과 성능의 균형을 제공.

- **VM과 독립적**:
  디스크가 VM에 의존하지 않으며, 다른 VM으로 쉽게 분리하거나 재할당할 수 있습니다.

- **스냅샷 지원**:
  Persistent Disk는 스냅샷을 통해 데이터를 백업하고 복원할 수 있습니다.

---

#### **장점**
- 고가용성과 내구성.
- 온라인 확장 및 백업 가능.
- 여러 VM에서 읽기 전용으로 공유 가능.

#### **단점**
- 네트워크를 통해 연결되므로 로컬 스토리지보다 지연 시간이 더 길 수 있음.

---

### **2. 로컬 SSD**

#### **특징**
- **VM에 직접 연결된 스토리지**:
  로컬 SSD는 VM의 물리적 호스트에 직접 연결된 스토리지로, 네트워크를 통하지 않으므로 매우 낮은 지연시간과 높은 IOPS를 제공합니다.

- **초고속 성능**:
  - 읽기/쓰기 대기 시간이 매우 짧아 데이터베이스, 캐싱, 임시 데이터 처리에 적합.
  - 최대 2,400,000 IOPS 및 9GB/s 이상의 읽기 속도.

- **휘발성 데이터**:
  로컬 SSD는 **VM이 중지되거나 재부팅되면 데이터가 삭제**됩니다. 따라서 장기 저장소로는 적합하지 않습니다.

- **고정 크기**:
  각 로컬 SSD는 375GB 크기로 제공되며, 최대 24개의 로컬 SSD를 연결할 수 있음.

- **스냅샷 불가능**:
  스냅샷이나 영구적인 데이터 저장이 지원되지 않음.

---

#### **장점**
- 매우 낮은 지연시간과 높은 성능.
- 고성능 임시 데이터 처리에 적합.

#### **단점**
- VM과 강하게 결합되어 있으며, VM 중지/재부팅 시 데이터 손실.
- 영구 데이터 저장 불가.
- 확장이 불편하며, Google이 제공하는 고정 크기를 사용해야 함.

---

### **3. 주요 차이점 비교**

| **특징**                | **Persistent Disk**                  | **로컬 SSD**                          |
|-------------------------|--------------------------------------|---------------------------------------|
| **연결 방식**            | 네트워크 기반                       | 호스트에 직접 연결                   |
| **성능**                | 적당히 빠름 (PD-SSD는 고성능)        | 매우 빠름                            |
| **지연시간**             | 로컬 SSD보다 길다                   | 매우 낮음                            |
| **데이터 내구성**         | 고내구성, VM과 독립적               | VM 재부팅/중지 시 데이터 손실         |
| **크기 조정**            | 동적으로 조정 가능                  | 고정 크기 (375GB 단위)               |
| **스냅샷 지원**          | 지원                               | 지원하지 않음                        |
| **주요 사용 사례**       | 일반적인 데이터 저장, 백업 및 아카이빙 | 캐싱, 임시 데이터, 고성능 워크로드 |

---

### **4. 사용 사례**

- **Persistent Disk**:
  - 데이터베이스 저장소.
  - 장기 데이터 저장.
  - 안정적이고 확장이 필요한 워크로드.

- **로컬 SSD**:
  - 고성능 캐싱.
  - 로그 처리 또는 임시 데이터 저장.
  - 데이터베이스의 고속 I/O 워크로드(예: Redis, Memcached).

---

### **결론**
Persistent Disk는 안정성과 유연성을, 로컬 SSD는 성능과 속도를 중시합니다. 선택은 워크로드의 요구사항에 따라 달라집니다. **장기 데이터 저장**이 필요하면 Persistent Disk를, **고성능 임시 작업**이 필요하면 로컬 SSD를 사용하는 것이 적합합니다.