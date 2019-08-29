
#!/bin/bash
function IP2long(){
  local IFS='.'
  read IP1 IP2 IP3 IP4 <<<"$1"
  echo $((IP1*256*256*256+IP2*256*256+IP3*256+IP4))
}

function long2IP(){
  local IP=$1
  local NET=
  NET=".$(( IP - (IP >> 8 << 8 ) ))${NET}"
  (( IP >>= 8 ))
  NET=".$(( IP - (IP >> 8 << 8 ) ))${NET}"
  (( IP >>= 8 ))
  NET=".$(( IP - (IP >> 8 << 8 ) ))${NET}"
  (( IP >>= 8 ))
  NET="${IP}${NET}"
  echo $NET
}

function cidr(){
  local IFS='~'
  local MASK=0
  local HOSTS=0
  read IPstart IPend <<<"$1"
  start=$(IP2long $IPstart)
  end=$(IP2long $IPend)
  while [ $MASK -le 32 ]
  do
    if [ $(( start + ( 1 << MASK) -1 )) -eq $end ];then
      echo "$IPstart/$(( 32-MASK))"
      break
    elif [ $(( start + (1 << MASK) -1 )) -gt $end ];then
      ((MASK--))
      echo "$IPstart/$(( 32-MASK))"
      (( start += (1<<MASK) ))
      IPstart=$(long2IP $start)
      MASK=0
    elif [ $(( (start>>MASK) % 2 )) -eq 1 ];then
      echo "$IPstart/$(( 32-MASK))"
      (( start += (1<<MASK) ))
      IPstart=$(long2IP $start)
      MASK=0
    else
      (( MASK ++ ))
    fi
  done
}

function formatIP(){
  case $1 in
    *~*)
      echo $1
      ;;
    */*)
      start=${1%/*}
      mask=${1#*/}
      if [ ${#mask} -gt 2 ];then
        end=$(( $(IP2long $start) + (1<<32) - $(IP2long $mask) -1 ))
      else
        end=$(( $(IP2long $start) + (1 << (32-mask)) -1 ))
      fi
      echo "$start~$(long2IP $end)"
      ;;
    *)
      echo
      ;;
  esac
}

read net1
net1=$(formatIP $net1)
start1=$(IP2long ${net1%~*})
end1=$(IP2long ${net1#*~})
while read net2
do
  net2=$(formatIP $net2)
  start2=$(IP2long ${net2%~*})
  end2=$(IP2long ${net2#*~})
  if [ $end1 -ge $end2 ];then
          continue
  elif [ $((end1+1)) -eq $start2 ];then
    end1=$end2
  else
    cidr "$(long2IP $start1)~$(long2IP $end1)"
    start1=$start2
    end1=$end2
  fi
done
cidr "$(long2IP $start1)~$(long2IP $end1)"
