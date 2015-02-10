#How many valid representations can an ISO 19115 (MI/MD) record have?


Starting point for each: minimum_valid_document.xml

Note: I will not be including all empty element structures. That's just padding the result set :/.

Example 1. No distribution.

```
<gmd:distributionInfo/>
```

Example 2. A single link in transferOptions 

```
<gmd:distributionInfo>
    <gmd:MD_Distribution>
        <gmd:transferOptions>
            <gmd:MD_DigitalTransferOptions>
                <gmd:onLine>
                    <gmd:CI_OnlineResource>
                        <gmd:linkage>
                            <gmd:URL>www.my_url.com</gmd:URL>
                        </gmd:linkage>
                    </gmd:CI_OnlineResource>
                </gmd:onLine>
            </gmd:MD_DigitalTransferOptions>
        </gmd:transferOptions>
    </gmd:MD_Distribution>
</gmd:distributionInfo>
```

Example 3. A single link with transfer size

```
<gmd:distributionInfo>
    <gmd:MD_Distribution>
        <gmd:transferOptions>
            <gmd:MD_DigitalTransferOptions>
                <gmd:transferSize>
                    <gco:Real>10.0</gco:Real>
                </gmd:transferSize>
                <gmd:onLine>
                    <gmd:CI_OnlineResource>
                        <gmd:linkage>
                            <gmd:URL>www.my_url.com</gmd:URL>
                        </gmd:linkage>
                    </gmd:CI_OnlineResource>
                </gmd:onLine>
            </gmd:MD_DigitalTransferOptions>
        </gmd:transferOptions>
    </gmd:MD_Distribution>
</gmd:distributionInfo>
```



