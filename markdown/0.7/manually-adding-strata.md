Title: Bedrock Linux 0.7 Poki Manually Adding Strata
Nav: poki.nav

Bedrock Linux 0.7 Poki Manually Adding Strata
=============================================

[brl fetch](commands.html#brl-fetch) can be used to automate acquiring Linux
distributions for use as ~{strata~}.  However, this supports a limited number of
distros and requires an internet connection.  ~{Strata~} may also be created
manually, which may be preferred in some situations.

To manually add a ~{stratum~}, get its contents into a new directory within
`/bedrock/strata` corresponding to the new ~{stratum~}'s name.  For example:

- {class="rcmd"}
- mkdir -p /mnt/~(lfs~)
- mount /dev/sda1 /mnt/~(lfs~)
- cp -a /mnt/~(lfs~) /bedrock/strata/~(lfs~)

Or for another example:

- {class="rcmd"}
- mkdir -p /bedrock/strata/~(example~)
- cd /bedrock/strata/~(example~)
- wget http://example.com/root.tar
- tar xf root.tar
- rm root.tar

By default, new ~{strata~} are ~{hidden~} to avoid accidentally being ~{enabled~} while the files are mid transfer into place.  Once you have completed placing the new ~{stratum~}'s files into `/bedrock/strata`, ~{show~} the ~{stratum~}:

- {class="rcmd"}
- brl show ~(new-stratum~)

Finally, to actually use the stratum, ~{enable~} it:

- {class="rcmd"}
- brl enable ~(new-stratum~)

New, manually acquired ~{strata~} may complain about missing users or groups.  If so, you may need to manually add them.  Such ~{strata~} may also complain about locale issues, in which case you may need to manually set up the given ~{stratum~}'s locale.
