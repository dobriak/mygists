#!/bin/bash
# Gather debugging information on top of the enforcer techsupport bundle
# Edit the configuration variables below before running it
#
# Your test pod can be found in /tenantId/cloudAccount/group/kubeNs
# Make sure that your apoctl is authorized to interact with that ^ namespace
#
tenantId=<long-id-here>
cloudAccount=<cloud-account-name>
group=<group-name>
kubeNs=<k8s-namespace-name>
ngroup=/${tenantId}/${cloudAccount}/${group}

apoOrg=$(apoctl auth verify | grep organization | cut -d ':' -f2 | sed -e 's/\"//g' -e 's/\,//g')
echo "Your apoctl authorization: $apoOrg"
echo "Attempting to collect aporeto infromation from $ngroup"

# Output directory
outDir=aporeto-info
if [ -d $outDir ]; then
	echo "$outDir exists, please consider removing or deleting."
	exit 1
fi
mkdir $outDir
pushd $outDir

# Gather information
apoctl reportsquery flows -n $ngroup --recursive --from-rel 1h > reports-flow.json
apoctl reportsquery connectionexceptions -n $ngroup --recursive --from-rel 1h > reports-connex.json
apoctl reportsquery dnslookups -n $ngroup --recursive --from-rel 1h > reports-dns.json

apoctl api export networkrulesetpolicy enforcerprofile enforcerprofilemappingpolicy apiauthorizationpolicy externalnetwork -n $ngroup > export-k8s.yaml
apoctl api export networkrulesetpolicy enforcerprofile enforcerprofilemappingpolicy apiauthorizationpolicy externalnetwork -n ${ngroup}/${kubeNs} > export-kubens.yaml

popd

# Tar the file so it can be attached to a ticket
tar zcvf aporeto-info_$(date +"%s").tar.gz $outDir
echo "Done, all aporeto information can be found in aporeto-info_*.tar.gz"
exit 0