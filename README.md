# Bigtable emulator Docker image

This docker image contains [Google Cloud SDK BigTable emulator](https://cloud.google.com/bigtable/docs/emulator) and
provides an easy setup using [cbt tool](https://cloud.google.com/bigtable/docs/quickstart-cbt).

Warning: This is not a production tool.

## Installation

A pre-built Docker container is available for Docker Hub:

```bash
docker run -p 8086:8086 ssivart/bigtable-emulator
```

## Usage

Use any client app to connect to emulator by setting the `BIGTABLE_EMULATOR_HOST` environment variable to 
the host and port where the Bigtable emulator is running.

```bash
env BIGTABLE_EMULATOR_HOST=localhost:8086 ./myapp
```

or

```bash
export BIGTABLE_EMULATOR_HOST=localhost:8086
./myapp
```

## Automatic table and column family creation

Specifying the `BIGTABLE_SCHEMA` environment variable with a sequential number appended to it, the format 
should be:

```bash
BIGTABLE_SCHEMA=TABLE1:FAMILY1#FAMILY2,TABLE2:FAMILY3,TABLE3:FAMILY4
```

Specifying the `BIGTABLE_PROJECT` and `BIGTABLE_INSTANCE` environment variable to set the project and 
instance, the default value is `dev`:

```bash
BIGTABLE_PROJECT=my-project-123
BIGTABLE_INSTANCE=my-instance
```

Full command would look like:

```bash
docker run -p 8086:8086 \
           -e BIGTABLE_SCHEMA=user:metadata#profile,company:metadata#finance \
           -e BIGTABLE_PROJECT=my-project \
           -e BIGTABLE_INSTANCE=my-instance \
           ssivart/bigtable-emulator
```