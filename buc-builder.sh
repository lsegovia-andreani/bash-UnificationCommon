#!/bin/sh
BUC=${BUC:-~/.bash-UnificationCommon}

login() {
  echo  
  echo "Login on openshift"
  echo
  read -p "User: " USER
  read -sp "Password: " PASSWORD
  OCPATH="$BUC/clients/oc"  
  PATH=$PATH:OCPATH
  oc login https://openshift.andreani.com.ar:443 --username="$USER" --password="$PASSWORD" && RESULT=0 || RESULT=1
  if [ $RESULT -eq 1 ]
  then
  echo -e "\e[91mLoging fail!\e[39m"
  exit 1
  else
    echo "Loging succesfully!"
    clear
  fi
  echo
  echo -e "\e[92mBuilder ready!\e[39m"
}

environments(){
  echo
  echo -e "\e[33mSelect environment:\e[39m"
  echo
  echo "1 - Staging"
  echo "2 - Production"
  echo
  read -p "Option: " ENV
  echo

  case "$ENV" in

    "1")
      echo "Environment: STAGING"
      NAME_SPACE="unificacion-test"
      ;;

    "2")
      echo "Environment: PRODUCTION"
      NAME_SPACE="unificacion-produccion"
      ;;
    *)
      echo -e "\e[91mEnvironment not found!\e[39m" && exit 1
      ;;
  esac
  echo

}


applications(){
  echo -e "\e[33mApplications:\e[39m"
  echo
  echo "1 - Unificacion Api"
  echo "2 - Unificacion Api Alertran"
  echo "3 - Unificacion Api Integra"
  echo "4 - Unificacion Home"
  echo "5 - Unificacion Planificacion"
  echo "6 - Unificacion Recepcion Expedicion"
  echo "7 - Unificacion Salida Distribucion"
  echo "8 - Unificacion Recepcion Expedicion"
  echo
  read -p "Option: " APP
  echo


  case "$APP" in

  "1")
    if [ $ENV -eq 1 ]
    then
        BUILD_CONFIG="test-api-unificacion-build"
    else
        BUILD_CONFIG="produccion-api-unificacion-build"
    fi
    echo "APPLICATION: Unificacion Api"
    ;;

  "2")
    if [ $ENV -eq 1 ]
    then
        BUILD_CONFIG="test-api-integra-build"
    else
        BUILD_CONFIG="produccion-api-integra-build"
    fi
      echo "APPLICATION: Unificacion Api Integra"
    ;;

  "3")
    if [ $ENV -eq 1 ]
    then
        BUILD_CONFIG="test-api-alertran-build"
    else
        BUILD_CONFIG="produccion-api-alertran-build"
    fi
      echo "APPLICATION: Unificacion Api Alertran"
    ;;

  "4")
    if [ $ENV -eq 1 ]
    then
        BUILD_CONFIG="test-unificacion"
    else
        BUILD_CONFIG="produccion-unificacion"
    fi
    echo "APPLICATION: Unificacion Home"
    ;;

  "5")
    if [ $ENV -eq 1 ]
    then
        BUILD_CONFIG="test-planificacion"
    else
        BUILD_CONFIG="produccion-planificacion"
    fi
      echo "APPLICATION: Unificacion Planificacion"
    ;;

  "6")
    if [ $ENV -eq 1 ]
    then
        BUILD_CONFIG="test-recepcionexpedicion"
    else
        BUILD_CONFIG="produccion-recepcionexpedicion"
    fi
      echo "APPLICATION: Unificacion Recepcion Expedicion"
    ;;

  "7")
    if [ $ENV -eq 1 ]
    then
        BUILD_CONFIG="test-salida-distribucion"
    else
        BUILD_CONFIG="produccion-salida-distribucion"
    fi
      echo "APPLICATION: Unificacion Salida Distribucion"
    ;;

  "8")
    if [ $ENV -eq 1 ]
    then
        BUILD_CONFIG="test-recepciondistribucion"
    else
        BUILD_CONFIG="produccion-recepciondistribucion"
    fi
      echo "APPLICATION: Unificacion Recepcion Distribucion"
    ;;
  
  *)
     echo -e "\e[91mApplication not found!!\e[39m" && exit 1
    ;;
  esac

}

build(){
  
  oc start-build "$BUILD_CONFIG" -n "$NAME_SPACE" && RESULT=0 || RESULT=1
  echo

  if [ $RESULT -eq 1 ]
  then
      echo -e "\e[91mError starting new build!\e[39m"
      exit 1
  else
      echo -e "\e[92mBuild completed!\e[39m"
  fi

}

main() {

  login
  environments
  applications
  build

}

main "$@"