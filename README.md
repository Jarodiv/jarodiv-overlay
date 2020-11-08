# jarodiv-overlay

Gentoo Overlay containing packages I have been unable to find in Portage Overlays or elsewhere. Testing and updating of these ebuilds is rather irregular.

## How to install

There generally are two methods to install this overlay.

### Layman

To install this overlay using `app-portage/layman`, run the following command

`layman -o https://raw.githubusercontent.com/Jarodiv/jarodiv-overlay/master/repositories.xml -f -a jarodiv-overlay`

More information on this can be found in the [Gentoo Wiki](https://wiki.gentoo.org/wiki/Layman#Adding_custom_repositories).

### Local repositories

To install this overlay as a [local repository](https://wiki.gentoo.org/wiki/Handbook:Parts/Portage/CustomTree#Defining_a_custom_repository), create a file `/etc/portage/repos.conf/jarodiv-overlay.conf` containing the following text:

```
[jarodiv-overlay]
priority = 50
location = /var/db/repos/jarodiv-overlay
sync-type = git
sync-uri = https://github.com/Jarodiv/jarodiv-overlay.git
auto-sync = Yes
```

Then run `emaint -r jarodiv-overlay sync`, Portage should now find and update the repository.