# linux 위에서 던파 돌리기

1. wine이 선행으로 설치되어야 합니다.
2. debian 계열보단 arch가, 그 중에서도 cachy OS에서 wine-cachy 버전 설치를 추천합니다.
3. 추후 다른 OS에서도 테스트한 뒤 OS별 실행 가능한 버전을 체크하겠습니다.

# 실행 방법
1. Neople Plugin을 wine으로 설치해주세요.
2. 현재 git을 clone 하시거나, setup-neople-handler.sh 를 다운로드 해주세요.
3. bash에서 setup-neople-handler.sh 를 실행해 주세요. (home 폴더에서 실행하는 것을 추천합니다.)

# 미리 찾은 trouble

1. 최초 설치 후 실행시 화면이 깨집니다.
   이 부분은 해결할 방법을 당장은 못 찾았습니다. wayland / x11 설정을 던파가 기본적으로 날려먹는데, 이걸 디버깅하기엔 너무 고통스러워서 (...) 그냥 놔뒀습니다.
   대신, 재부팅 시 제대로 실행됩니다. 재부팅 꼭 해주세요.
