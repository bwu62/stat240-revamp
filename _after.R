# copy demo.html if inexistent or changed
if(
  file.exists("demo.html") && (
    !file.exists("docs/demo.html") || 
    file.info("demo.html")$mtime >=
    file.info("docs/demo.html")$mtime
  )
) file.copy("demo.html","docs/",overwrite=T)
