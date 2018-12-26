Title: Bedrock Linux 0.7 Poki Removing the Hijacked Stratum
Nav: poki.nav

Bedrock Linux 0.7 Poki Removing the Hjiacked Stratum
====================================================

The ~{stratum~} resulting from the ~{hijack~} of the initial install may be removed.  Some considerations:

- The ~{stratum~} *currently* providing `init` may not be removed (as that would crash the system).  If you are using the ~{hijacked~} ~{stratum~}, first reboot and select another ~{stratum~} to provide `init` for the session.
- By default, the ~{hijacked~} ~{stratum~} maintains your bootloader.  After removing the ~{hijacked~} ~{stratum~} the bootloader will continue to work - you can boot - but it will not automatically update with new kernels or initrds.  If you know how to manually maintain the bootloader, you are welcome to do so.  If you would prefer to have another ~{stratum~} maintain the bootloader, simply install its bootloader over the existing one.  Many distros provide a `grub` or `grub2` package which is suitable.  It may be wise to do this *first*, before removing the ~{hijacked~} ~{stratum~}, to ensure the bootloader hand-off goes smoothly before removing the ~{hijacked~} ~{stratum~}.
- Bedrock creates a `hijacked` ~{alias~} during the ~{hijack~} process which can be used to determine which ~{stratum~} is the ~{hijacked~} one, should you have forgotten: `brl deref hijacked`
- [brl remove](commands.html#brl-remove) command can be used to remove ~{strata~}, such as the `hijacked` ~{stratum~}: `{class="rcmd"} brl remove $(brl deref hijacked)`
