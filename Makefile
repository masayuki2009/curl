############################################################################
# apps/external/curl/Makefile
#
#   Copyright 2018 Sony Video & Sound Products Inc.
#   Author: Masayuki Ishikawa <Masayuki.Ishikawa@jp.sony.com>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
# 3. Neither the name NuttX nor the names of its contributors may be
#    used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
############################################################################

-include $(TOPDIR)/.config
-include $(TOPDIR)/Make.defs
include $(APPDIR)/Make.defs

MBEDTLSDIR = $(APPDIR)/external/mbedtls
NGHTTP2DIR = $(APPDIR)/external/nghttp2

CFLAGS += -I ./include
CFLAGS += -I ./lib
CFLAGS += -I$(MBEDTLSDIR)/include
CFLAGS += -I$(NGHTTP2DIR)/lib/includes
CFLAGS += -DNUTTX -DHAVE_CONFIG_H
CFLAGS += -DBUILDING_LIBCURL
#CFLAGS += -DMBEDTLS_DEBUG

ASRCS	=
CSRCS	=

ifeq ($(CONFIG_EXTERNAL_CURL),y)
CSRCS += lib/base64.c
CSRCS += lib/conncache.c
CSRCS += lib/connect.c
CSRCS += lib/content_encoding.c
CSRCS += lib/cookie.c
CSRCS += lib/curl_addrinfo.c
CSRCS += lib/curl_ctype.c
CSRCS += lib/curl_endian.c
CSRCS += lib/curl_gethostname.c
CSRCS += lib/curl_memrchr.c
CSRCS += lib/curl_ntlm_core.c
CSRCS += lib/curl_ntlm_wb.c
CSRCS += lib/doh.c
CSRCS += lib/dotdot.c
CSRCS += lib/easy.c
CSRCS += lib/escape.c
CSRCS += lib/fileinfo.c
CSRCS += lib/formdata.c
CSRCS += lib/getenv.c
CSRCS += lib/getinfo.c
CSRCS += lib/hash.c
CSRCS += lib/hmac.c
CSRCS += lib/hostasyn.c
CSRCS += lib/hostip.c
CSRCS += lib/hostip4.c
CSRCS += lib/hostip6.c
CSRCS += lib/hostsyn.c
CSRCS += lib/http.c
CSRCS += lib/http_chunks.c
CSRCS += lib/http_digest.c
CSRCS += lib/http2.c
CSRCS += lib/http_ntlm.c
CSRCS += lib/http_proxy.c
CSRCS += lib/if2ip.c
CSRCS += lib/llist.c
CSRCS += lib/md4.c
CSRCS += lib/md5.c
CSRCS += lib/memdebug.c
CSRCS += lib/mime.c
CSRCS += lib/mprintf.c
CSRCS += lib/multi.c
CSRCS += lib/netrc.c
CSRCS += lib/nonblock.c
CSRCS += lib/parsedate.c
CSRCS += lib/pipeline.c
CSRCS += lib/progress.c
CSRCS += lib/rand.c
CSRCS += lib/select.c
CSRCS += lib/sendf.c
CSRCS += lib/setopt.c
CSRCS += lib/sha256.c
CSRCS += lib/share.c
CSRCS += lib/slist.c
CSRCS += lib/socks.c
CSRCS += lib/speedcheck.c
CSRCS += lib/splay.c
CSRCS += lib/strcase.c
CSRCS += lib/strdup.c
CSRCS += lib/strerror.c
CSRCS += lib/strtoofft.c
CSRCS += lib/timeval.c
CSRCS += lib/transfer.c
CSRCS += lib/url.c
CSRCS += lib/urlapi.c
CSRCS += lib/version.c
CSRCS += lib/vauth/digest.c
CSRCS += lib/vauth/ntlm.c
CSRCS += lib/vtls/mbedtls.c
CSRCS += lib/vtls/vtls.c
CSRCS += lib/warnless.c
CSRCS += lib/wildcard.c
endif

AOBJS		= $(ASRCS:.S=$(OBJEXT))
COBJS		= $(CSRCS:.c=$(OBJEXT))

SRCS		= $(ASRCS) $(CSRCS)
OBJS		= $(AOBJS) $(COBJS)

ifeq ($(CONFIG_WINDOWS_NATIVE),y)
  BIN		= $(TOPDIR)\staging\libcurl$(LIBEXT)
else
ifeq ($(WINTOOL),y)
  BIN		= $(TOPDIR)\\staging\\libcurl$(LIBEXT)
else
  BIN		= $(TOPDIR)/staging/libcurl$(LIBEXT)
endif
endif

ROOTDEPPATH	= --dep-path .

# Common build

VPATH		=

all: .built
.PHONY: context depend clean distclean preconfig
.PRECIOUS: $(TOPDIR)/staging/libcurl$(LIBEXT)

$(AOBJS): %$(OBJEXT): %.S
	$(call ASSEMBLE, $<, $@)

$(COBJS): %$(OBJEXT): %.c
	$(call COMPILE, $<, $@)

.built: $(OBJS)
	$(call ARCHIVE, $(BIN), $(OBJS))
	$(Q) touch .built

install:

context:

.depend: Makefile $(SRCS)
	$(Q) $(MKDEP) $(ROOTDEPPATH) "$(CC)" -- $(CFLAGS) -- $(SRCS) >Make.dep
	$(Q) touch $@

depend: .depend

clean:
	$(call DELFILE, .built)
	$(call CLEAN)

distclean: clean
	$(call DELFILE, Make.dep)
	$(call DELFILE, .depend)

preconfig:

-include Make.dep
