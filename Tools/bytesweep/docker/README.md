# Bytesweep Docker Containers

## Dev Environment Setup

NOTE: this will change (get easier) when the repos are made public

NOTE: if you have something else listening on ports 8000 or 5432 this will fail.

1. clone this repo
```
git clone https://gitlab.com/bytesweep/bytesweep.git
cd bytesweep
```

3. Build docker containers. This may take awhile.
```
./build-bytesweep.sh
```

4. Start docker containers
```
./start-bytesweep.sh
```

5. Navigate to bytesweep at http://127.0.0.1:8000
