#### Contribution Guide

### Summary

This project follows [Semantic Versioning 2.0](https://semver.org/). In general, every release is associated with a tag and a changelog. `master` serves as the mainline branch for the project and represent the latest state of development.

### Publishing a New SDK version
```bash
# update podspecs for affected modules in relation to semver as it applies
# Only StitchCore and pods depending on it are updated. For example this
# excludes ExtendedJson. So if that were to update, you must manually bump
# its version.

# run bump_version.bash with either patch, minor, or major
./bump_version.bash <patch|minor|major>

# make live
VERSION=`cat StitchCore.podspec | grep "s.version" | head -1 | sed -E 's/[[:space:]]+s\.version.*=.*"(.*)"/\1/'`
for spec in *.podspec ; do
	name=`echo $spec | sed -E 's/(.*)\.podspec/\1/'`
	if pod trunk info $name | grep "$VERSION" > /dev/null; then
		continue
	fi
	echo pushing $spec @ $VERSION to trunk
	pod trunk push $spec
done

# send an email detailing the changes to the https://groups.google.com/d/forum/mongodb-stitch-announce mailing list
```

### Patch Versions

The work for a patch version should happen on a "support branch" (e.g. 1.2.x). The purpose of this is to be able to support a minor release while excluding changes from the mainstream (`master`) branch. If the changes in the patch are relevant to other branches, including `master`, they should be backported there. The general publishing flow can be followed using `patch` as the bump type in `bump_version`.

### Minor Versions

The general publishing flow can be followed using `minor` as the bump type in `bump_version`.

### Major Versions

The general publishing flow can be followed using `major` as the bump type in `bump_version`. In addition to this, the release on GitHub should be edited for a more readable format of key changes and include any migration steps needed to go from the last major version to this one.