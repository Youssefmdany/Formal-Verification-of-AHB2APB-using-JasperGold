clear -all


analyze -sv09 -f jg_ahb2abp.f

analyze -sv09 bridge_top_sva.sv


elaborate -top bridge_top -create_related_cover witness

clock Hclk
reset ~Hresetn

prove -bg -all

