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

Example 4. A basic distributionFormat block

```
<gmd:distributionInfo>
    <gmd:MD_Distribution>
        <gmd:distributionFormat>
            <gmd:MD_Format>
                <gmd:name>
                    <gco:CharacterString>A Format</gco:CharacterString>
                </gmd:name>
                <gmd:version>
                    <gco:CharacterString>1.0</gco:CharacterString>
                </gmd:version>
            </gmd:MD_Format>
        </gmd:distributionFormat>
    </gmd:MD_Distribution>
</gmd:distributionInfo>
```

Example 5. A distribution format with a format distributor (context matters but we'll just consider any URL endpoint here).

```
<gmd:distributionInfo>
    <gmd:MD_Distribution>
        <gmd:distributionFormat>
            <gmd:MD_Format>
                <gmd:name>
                    <gco:CharacterString>A Format</gco:CharacterString>
                </gmd:name>
                <gmd:version>
                    <gco:CharacterString>1.0</gco:CharacterString>
                </gmd:version>
                <gmd:formatDistributor>
                    <gmd:MD_Distributor>
                        <gmd:distributorContact/>
                        <gmd:distributorTransferOptions>
                            <gmd:MD_DigitalTransferOptions>
                                <gmd:onLine>
                                    <gmd:CI_OnlineResource>
                                        <gmd:linkage>
                                            <gmd:URL>www.my_url.com</gmd:URL>
                                        </gmd:linkage>
                                    </gmd:CI_OnlineResource>
                                </gmd:onLine>
                            </gmd:MD_DigitalTransferOptions>
                        </gmd:distributorTransferOptions>
                    </gmd:MD_Distributor>
                </gmd:formatDistributor>
            </gmd:MD_Format>
        </gmd:distributionFormat>
    </gmd:MD_Distribution>
</gmd:distributionInfo>
```

Example 6. Basic distributor (seeing a pattern here)

```
<gmd:distributionInfo>
    <gmd:MD_Distribution>
        <gmd:distributor>
            <gmd:MD_Distributor>
                <gmd:distributorContact/>
                <gmd:distributorTransferOptions>
                    <gmd:MD_DigitalTransferOptions>
                        <gmd:onLine>
                            <gmd:CI_OnlineResource>
                                <gmd:linkage>
                                    <gmd:URL>www.my_url.com</gmd:URL>
                                </gmd:linkage>
                            </gmd:CI_OnlineResource>
                        </gmd:onLine>
                    </gmd:MD_DigitalTransferOptions>
                </gmd:distributorTransferOptions>
            </gmd:MD_Distributor>
        </gmd:distributor>
    </gmd:MD_Distribution>
</gmd:distributionInfo>
```



