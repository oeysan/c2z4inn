---
title: 'imageseg: An R package for deep learning‐based image segmentation'
type: pub
encoding: UTF-8

---
<h1>Publication</h1>
<article id="csl-bib-container-GP4AKBE7" class="csl-bib-container">
  <div class="csl-bib-body"> <div class="csl-entry">Niedballa, J., Axtner, J., Döbert, T. F., Tilker, A., Nguyen, A., Wong, S. T., Fiderer, C., Heurich, M., &#38; Wilting, A. (2022). imageseg: An R package for deep learning‐based image segmentation. <i>Methods in Ecology and Evolution</i>, <i>13</i>(11), 2363–2371. <a href="https://doi.org/10.1111/2041-210x.13984">https://doi.org/10.1111/2041-210x.13984</a></div> </div>
  <div class="csl-bib-buttons">
    <a href="#taxonomy-article-GP4AKBE7" alt="archive" class="csl-bib-button">Archive</a>
    <a href="https://app.cristin.no/results/show.jsf?id=2075050" alt="Cristin" class="csl-bib-button">Cristin</a>
    <a href="http://zotero.org/groups/5881554/items/GP4AKBE7" alt="Zotero" class="csl-bib-button">Zotero</a>
    <a href="#keywords-article-GP4AKBE7" alt="keywords" class="csl-bib-button">Keywords</a>
    <a href="#about-article-GP4AKBE7" alt="about_pub" class="csl-bib-button">About</a>
    <a href="#sdg-article-GP4AKBE7" alt="sdg" class="csl-bib-button">Sustainable Development Goals</a>
    <a href="https://repository.publisso.de/resource/frl:6452617/data" alt="Unpaywall" class="csl-bib-button">Unpaywall</a>
    <a href="https://repository.publisso.de/resource/frl:6452617/data" alt="EZproxy" class="csl-bib-button">EZproxy</a>
  </div>
  <div id="csl-bib-meta-container-GP4AKBE7"></div>
</article>
<div id="csl-bib-meta-GP4AKBE7" class="csl-bib-meta">
  <article id="about-article-GP4AKBE7" class="about_pub-article">
    <h1>About</h1>
    Niedballa et al. developed an R package called imageseg to simplify the use of deep learning for image segmentation, which involves classifying all pixels in an image. This tool is particularly useful for ecologists who study forest structures, like tree canopy density and understorey vegetation density. The package uses advanced models, U-Net and U-Net++, to process images and make predictions. It demonstrated high accuracy, outperforming traditional methods, and worked well across different forest types. By making this package free and open source, the authors aim to make deep learning more accessible for ecological research and other fields, such as cell biology and medical imaging. This can help researchers quickly and effectively analyze complex image data.
  </article>
  <article id="keywords-article-GP4AKBE7" class="keywords-article">
    <h1>Keywords</h1>
    Image Segmentation, Convolutional Neural Networks, Deep Learning, Forest Structural Metrics, Canopy Density, Understorey Vegetation Density
  </article>
  <article id="abstract-article-GP4AKBE7" class="abstract-article">
    <h1>Scientific abstract</h1>
    Convolutional neural networks (CNNs) and deep learning are powerful and robust tools for ecological applications, and are particularly suited for image data. Image segmentation (the classification of all pixels in images) is one such application and can, for example, be used to assess forest structural metrics. While CNN‐based image segmentation methods for such applications have been suggested, widespread adoption in ecological research has been slow, likely due to technical difficulties in implementation of CNNs and lack of toolboxes for ecologists. Here, we present R package imageseg which implements a CNN‐based workflow for general purpose image segmentation using the U‐Net and U‐Net++ architectures in R. The workflow covers data (pre)processing, model training and predictions. We illustrate the utility of the package with image recognition models for two forest structural metrics: tree canopy density and understorey vegetation density. We trained the models using large and diverse training datasets from a variety of forest types and biomes, consisting of 2877 canopy images (both canopy cover and hemispherical canopy closure photographs) and 1285 understorey vegetation images. Overall segmentation accuracy of the models was high with a Dice score of 0.91 for the canopy model and 0.89 for the understorey vegetation model (assessed with 821 and 367 images respectively). The image segmentation models performed significantly better than commonly used thresholding methods, and generalized well to data from study areas not included in training. This indicates robustness to variation in input images and good generalization strength across forest types and biomes. The package and its workflow allow simple yet powerful assessments of forest structural metrics using pretrained models. Furthermore, the package facilitates custom image segmentation with single or multiple classes and based on colour or grayscale images, for example, for applications in cell biology or for medical images. Our package is free, open source and available from CRAN. It will enable easier and faster implementation of deep learning‐based image segmentation within R for ecological applications and beyond.
  </article>
  <article id="sdg-article-GP4AKBE7" class="sdg-article">
    <h1>Sustainable Development Goals</h1>
    <div class="sdg-container"><div id="sdg13" class="sdg">
        <img src="{{< params subfolder >}}images/sdg/sdg13_en.png" class="image" alt="SDG 13">
        <div class="sdg-overlay">
          <a href="{{< params subfolder >}}en/archive/?sdg=13#archive" class="sdg-publication-count"><span>260</span> Publications</a>
          <p><a href="https://sdgs.un.org/goals/goal13" class="sdg-read-more">Read More</a></p>
        </div>
      </div> <div id="sdg15" class="sdg">
        <img src="{{< params subfolder >}}images/sdg/sdg15_en.png" class="image" alt="SDG 15">
        <div class="sdg-overlay">
          <a href="{{< params subfolder >}}en/archive/?sdg=15#archive" class="sdg-publication-count"><span>544</span> Publications</a>
          <p><a href="https://sdgs.un.org/goals/goal15" class="sdg-read-more">Read More</a></p>
        </div>
      </div></div>
  </article>
  <article id="taxonomy-article-GP4AKBE7" class="taxonomy-article">
    <h1>Archive</h1>
    <ul>
      <li><a href="{{< params subfolder >}}en/archive/?key=3DCRN523">University of Inland Norway</a></li>
      <li><a href="{{< params subfolder >}}en/archive/?key=T77LXH6D">Faculty of Applied Ecology, Agricultural Sciences and Biotechnology</a></li>
      <li><a href="{{< params subfolder >}}en/archive/?key=7TRARPE3">Department of Forestry and Wildlife Management</a></li>
      <li><a href="{{< params subfolder >}}en/archive/?key=H9K9UC39">2022</a></li>
      <li><a href="{{< params subfolder >}}en/archive/?key=A2LGFBDJ">November</a></li>
    </ul>
  </article>
</div>
