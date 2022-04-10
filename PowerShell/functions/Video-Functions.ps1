Function Cut-Video {
	ffmpeg -i $args[0] -ss $args[1] -to $args[2] -y .\out.mp4
}

Function Cut-Video-Copy {
	ffmpeg -i $args[0] -ss $args[1] -to $args[2] -c:v copy -c:a copy -y .\out.mp4
}

Function Compress-Video {
	ffmpeg -i $args[0] -b:v 12800k -c:a copy -y .\out.mp4
}

Function Launch-Switch-Dvr {
	dotnet 'E:\ProgramFiles\SysDVR-Client\SysDVR-Client.dll' bridge 192.168.2.2
}
