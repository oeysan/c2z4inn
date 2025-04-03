---
title: 'imageseg: An R package for deep learning‐based image segmentation'
type: pub
encoding: UTF-8

---
<h1>Publikasjon</h1>
<article id="csl-bib-container-GP4AKBE7" class="csl-bib-container">
  <div class="csl-bib-body"> <div class="csl-entry">Niedballa, J., Axtner, J., Döbert, T. F., Tilker, A., Nguyen, A., Wong, S. T., Fiderer, C., Heurich, M., &#38; Wilting, A. (2022). imageseg: An R package for deep learning‐based image segmentation. <i>Methods in Ecology and Evolution</i>, <i>13</i>(11), 2363–2371. <a href="https://doi.org/10.1111/2041-210x.13984">https://doi.org/10.1111/2041-210x.13984</a></div> </div>
  <div class="csl-bib-buttons">
    <a href="#taxonomy-article-GP4AKBE7" alt="archive" class="csl-bib-button">Arkiv</a>
    <a href="https://app.cristin.no/results/show.jsf?id=2075050" alt="Cristin" class="csl-bib-button">Cristin</a>
    <a href="http://zotero.org/groups/5881554/items/GP4AKBE7" alt="Zotero" class="csl-bib-button">Zotero</a>
    <a href="#keywords-article-GP4AKBE7" alt="keywords" class="csl-bib-button">Emneord</a>
    <a href="#about-article-GP4AKBE7" alt="about_pub" class="csl-bib-button">Om</a>
    <a href="#sdg-article-GP4AKBE7" alt="sdg" class="csl-bib-button">Berekraftsmål</a>
    <a href="https://repository.publisso.de/resource/frl:6452617/data" alt="Unpaywall" class="csl-bib-button">Unpaywall</a>
    <a href="https://repository.publisso.de/resource/frl:6452617/data" alt="EZproxy" class="csl-bib-button">EZproxy</a>
  </div>
  <div id="csl-bib-meta-container-GP4AKBE7"></div>
</article>
<div id="csl-bib-meta-GP4AKBE7" class="csl-bib-meta">
  <article id="about-article-GP4AKBE7" class="about_pub-article">
    <h1>Om</h1>
    Niedballa et al. utvikla ei R-pakke kalla imageseg for å forenkle bruken av djup læring til biletesegmentering, som inneber klassifisering av alle pikslane i eit bilete. Dette verktøyet er særleg nyttig for økologar som studerer skogstrukturar, som trekrone-tettleik og undervegetasjonstettleik. Pakka nyttar avanserte modellar, U-Net og U-Net++, til å prosessere bilete og gjere prediksjonar. Den viste høg nøyaktigheit, overgjekk tradisjonelle metodar, og fungerte godt på tvers av ulike skogtypar. Ved å gjere denne pakka gratis og open kjeldekode, har forfattarane som mål å gjere djup læring meir tilgjengeleg for økologisk forsking og andre felt, som cellebiologi og medisinsk biletebehandling. Dette kan hjelpe forskarar med å raskt og effektivt analysere kompleks biletdata.
  </article>
  <article id="keywords-article-GP4AKBE7" class="keywords-article">
    <h1>Emneord</h1>
    Biletesegmentering, Konvolusjonelle nevrale nettverk, Djup læring, Skogstrukturelle metrikar, R-pakke, Økologiske applikasjonar
  </article>
  <article id="abstract-article-GP4AKBE7" class="abstract-article">
    <h1>Samandrag</h1>
    Convolutional neural networks (CNNs) and deep learning are powerful and robust tools for ecological applications, and are particularly suited for image data. Image segmentation (the classification of all pixels in images) is one such application and can, for example, be used to assess forest structural metrics. While CNN‐based image segmentation methods for such applications have been suggested, widespread adoption in ecological research has been slow, likely due to technical difficulties in implementation of CNNs and lack of toolboxes for ecologists. Here, we present R package imageseg which implements a CNN‐based workflow for general purpose image segmentation using the U‐Net and U‐Net++ architectures in R. The workflow covers data (pre)processing, model training and predictions. We illustrate the utility of the package with image recognition models for two forest structural metrics: tree canopy density and understorey vegetation density. We trained the models using large and diverse training datasets from a variety of forest types and biomes, consisting of 2877 canopy images (both canopy cover and hemispherical canopy closure photographs) and 1285 understorey vegetation images. Overall segmentation accuracy of the models was high with a Dice score of 0.91 for the canopy model and 0.89 for the understorey vegetation model (assessed with 821 and 367 images respectively). The image segmentation models performed significantly better than commonly used thresholding methods, and generalized well to data from study areas not included in training. This indicates robustness to variation in input images and good generalization strength across forest types and biomes. The package and its workflow allow simple yet powerful assessments of forest structural metrics using pretrained models. Furthermore, the package facilitates custom image segmentation with single or multiple classes and based on colour or grayscale images, for example, for applications in cell biology or for medical images. Our package is free, open source and available from CRAN. It will enable easier and faster implementation of deep learning‐based image segmentation within R for ecological applications and beyond.
  </article>
  <article id="sdg-article-GP4AKBE7" class="sdg-article">
    <h1>Berekraftsmål</h1>
    <div class="sdg-container"><div id="sdg13" class="sdg">
        <img src="{{< params subfolder >}}images/sdg/sdg13_nn.png" class="image" alt="SDG 13">
        <div class="sdg-overlay">
          <a href="{{< params subfolder >}}nn/archive/?sdg=13#archive" class="sdg-publication-count"><span>260</span> publikasjonar</a>
          <p><a href="https://fn.no/om-fn/fns-baerekraftsmaal/stoppe-klimaendringene?lang=nno-NO" class="sdg-read-more">Les meir</a></p>
        </div>
      </div> <div id="sdg15" class="sdg">
        <img src="{{< params subfolder >}}images/sdg/sdg15_nn.png" class="image" alt="SDG 15">
        <div class="sdg-overlay">
          <a href="{{< params subfolder >}}nn/archive/?sdg=15#archive" class="sdg-publication-count"><span>544</span> publikasjonar</a>
          <p><a href="https://fn.no/om-fn/fns-baerekraftsmaal/livet-paa-land?lang=nno-NO" class="sdg-read-more">Les meir</a></p>
        </div>
      </div></div>
  </article>
  <article id="taxonomy-article-GP4AKBE7" class="taxonomy-article">
    <h1>Arkiv</h1>
    <ul>
      <li><a href="{{< params subfolder >}}nn/archive/?key=3DCRN523">Universitetet i Innlandet</a></li>
      <li><a href="{{< params subfolder >}}nn/archive/?key=T77LXH6D">Fakultet for anvendt økologi, landbruksfag og bioteknologi</a></li>
      <li><a href="{{< params subfolder >}}nn/archive/?key=7TRARPE3">Institutt for skog- og utmarksfag</a></li>
      <li><a href="{{< params subfolder >}}nn/archive/?key=H9K9UC39">2022</a></li>
      <li><a href="{{< params subfolder >}}nn/archive/?key=A2LGFBDJ">November</a></li>
    </ul>
  </article>
</div>
