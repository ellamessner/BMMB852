# Week 1 Assignment

## Create week01 directory
```
cd ~/BMMB852
mkdir week01
```

## Create week01 README file
```
cd week01
touch README.md
```

## Determine samtools version
```
samtools --version
    samtools 1.22.1
```
### Output: ###
```
samtools 1.22.1
Using htslib 1.22.1
Copyright (C) 2025 Genome Research Ltd.
```

## Create a nested directory structure
```
mkdir -p dir1/dir2/dir3
```
## Show commands that create files in different directories
### Create a file in dir1
```
cd dir1
touch file1
```

### Create a file in dir2
```
touch dir2/file2
```

### Create a file in dir3
```
touch dir2/dir3/file3
```

## Show how to use relative and absolute paths
### Relative path example
```
cd ..
pwd
```
#### Output: ####
```
/Users/ellamessner/BMMB852/week01
```

### Absolute path example
```
cd ~/BMMB852/week01/dir1/dir2
pwd
```

#### Output: ####
```
/Users/ellamessner/BMMB852/week01
```

