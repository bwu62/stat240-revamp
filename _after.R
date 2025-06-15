# copy if inexistent or changed
copy.file = function(file,dest=NULL){
  if(is.null(dest)){
    dest=paste0("docs/",file)
  }
  if(
    file.exists(file) && (
      !file.exists(paste0("docs/",file)) || 
      file.info(file)$mtime >=
      file.info(paste0("docs/",file))$mtime
    )
  ) file.copy(file,dest,overwrite=T)
}

# list of extra files/dirs to copy
copy.list = c(
  "demo.html",
  "data/",
  "misc/",
  "data_list.txt",
  "icons/",
  "ggplot_theme_options.R",
  "joins.svg"
)

# iterate over copy list
for(path in copy.list){
  # check if item is file or directory
  if(dir.exists(path)){
    # if directory doesn't exist, create it
    if(!dir.exists(paste0("docs/",path))){
      dir.create(paste0("docs/",path))
    }
    for(file in list.files(path)){
      copy.file(paste0(path,file))
    }
  } else if(file.exists(path)){
    copy.file(path)
  } else warning("Path wrong in copy list!")
}
