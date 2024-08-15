# verusd

The variable VERUS_VERSION needs to be updated to the version you want to d/l. For example, after an update announcement, change it.

This was taken from [oinks auto-verus.sh script](https://github.com/Oink70/Verus-CLI-tools/blob/main/auto-verus.sh)

# using verusd
It gets built to an image called komodefi/verusd:0.1

It can then be used in docker-compose.yaml files.

It requires zcash params from the host which can be loaded as a volume at runtime and read-only.
