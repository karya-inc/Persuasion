#!/bin/bash

groups=('control' 'explicit' 'latent')
tasks=('voice_recording' 'image_annotation' 'audio_transcription')

remote_base_path="karya@scripts-service.centralindia.cloudapp.azure.com:/mnt/scripts-service-fileshare/Divyansh/persuasion"

for task in "${tasks[@]}"; do
  for group in "${groups[@]}"; do
    local_dir="./${task}/"
    mkdir -p "$local_dir"
    remote_file="${remote_base_path}/${task}_${group}_logs.csv"
    scp "$remote_file" "$local_dir"
  done
done

echo "All files have been successfully copied."
