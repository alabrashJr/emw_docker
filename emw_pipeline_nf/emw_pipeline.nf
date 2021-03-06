#!/usr/bin/env nextflow
params.input = "$baseDir/data/*.html"
params.outdir = "$baseDir/results"

inChannelA = Channel.fromPath(params.input)
inChannelB=Channel.fromPath(params.input)


process clean {
    input:
    file(fa) from inChannelA
    output:
        file("*.clean.json") into channelA

    script:
        """
      clean.py $fa
        """
}
process DTC {
    input:
        file(fa) from inChannelB
    output:
        file("*.DTC.json") into DTC_out
        //stdout DTC_result
    script:
    """
     PublishDateGraper_DTC-nextflow.py $fa
    """
}
//DTC_result.subscribe { println it }


process classifier {
    input:
        file(fa) from channelA

    output:
        file("*.*classifier.json") into (channelB,channelC)
        //dene1=Channel.from(channelB)
       // stdout ChannelL

    script:

        """
        classifier.py $fa
        """
}

//ChannelL.subscribe { println it }


process placeTagger {
input:
file(fa) from channelB
// output:
// file("*.placeTagger.json") into PT_out
//stdout PC_result
script:
//println( fa==~/^[a-zA-Z0-9]*\.classifier\.json$/ )
if ( fa==~/^[a-zA-Z0-9]*\.classifier\.json$/ ){
    """
        placeTagger.py $fa
     """
    }
else{
    """
        echo '{"identifier":"$fa","status":"non protest" }' > placeTagger.json
    """
}
        
// """
// placeTagger.py $fa
// """
}

process temporalTagger {
input:
file(fa) from channelC

// output:
// file("*.temporalTagger.json") into TT_out

script:
if ( fa==~/^[a-zA-Z0-9]*\.classifier\.json$/ ){
   """
    temporalTagger.py $fa
    """
    }
else{
    """
    echo '{"identifier":"$fa","status":"non protest" }' > temporalTagger.json

    """
}

}
// Channel
//     .from( '5.classifier.json', '6.classifier.json','emo.classifier.json',"3.0classifier.json","demo1.0classifier.json","demo2.0classifier.json")
//     .filter( ~/^[a-zA-Z0-9]*\.classifier\.json$/ )
//     .subscribe { println it }




