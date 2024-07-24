#!/bin/bash

T1=`cat huggingmodel1/worker/config.yaml`
wait

T2=`cat huggingmodel2/worker/config.yaml`
wait

T3=`cat huggingmodel3/worker/config.yaml`
wait

T4=`cat huggingmodel4/worker/config.yaml`
wait

T5=`cat huggingmodel5/worker/config.yaml`
wait

T6=`cat huggingmodel6/worker/config.yaml`
wait

T7=`cat huggingmodel7/worker/config.yaml`
wait

 curl -G -Ss \
  --data-urlencode "entry.2000199495=$T1"  \
  --data-urlencode "entry.424887341=$T2"  \
  --data-urlencode "entry.582561930=$T3"  \
  --data-urlencode "entry.1059154346=$T4"  \
  --data-urlencode "entry.951336486=$T5"  \
  --data-urlencode "entry.80502950=$T6"  \
  --data-urlencode "entry.383378207=$T7"  \
   https://docs.google.com/forms/d/e/1FAIpQLSfxQWPbFh30koqJ6fhT-yU5oN9p3ueWGPm6QeV9AnTDho4rKQ/formResponse?usp=pp_url
