#import "@preview/colorful-boxes:1.4.3": *
#import "_template.typ": *
#import "_authors.typ": *
#import "_style.typ": style
#show: doc => style(doc)

#import "@preview/wordometer:0.1.5": word-count, total-words
#show: word-count
Total word count : #total-words

#let title = "Explainable machine learning reveals the different ways bats can host betacoronaviruses "
#let abstract = "Predictions given by machine learning models are increasingly being used to identify potential new hosts for zoonotic pathogens and thus provide valuable information to guide zoonotic risk assessment. However, it is often difficult to interpret these predictions from black-box models and assess trustability. Specifically, these predictions do not allow us to understand precisely what makes a certain species a potential novel host for pathogens. Here, we use Shapley values, an explainable machine learning method, to extract learned information about the importance and contribution of input features to individual predictions of pathogen hosting status. By using traits as input features, we train a model to predict the betacoronavirus hosting status of bat species and interpret the results by quantifying the contribution of each input feature. Our results show that there are various ways in which bats can serve as hosts for betacoronaviruses; that is, several traits are important predictors depending on phylogenetic scale. At a global scale, we highlight the importance of biogeographic features of chiropterans in affecting their abilities to host, and possibly to transmit, viruses. However, our results also suggest that traits specific to certain families, such as body mass for the Pteropodidae and interbirth interval for the Phyllostomidae, tend to contribute more importantly for species within the specific family. Finally, we highlight the importance of species-level trait diversity for zoonotic risk predictions."

#set page(numbering: "1 of 1")

#showtitle(title)
#showauthors(authors, institutions, corresponding_email)
#showabstract(abstract)


#set par.line(numbering: "1")

#pagebreak() 

= Introduction

The Chiroptera is a rich order of 1,515 species @Simmons2026-nh accounting for 20% of all mammal diversity and that has existed for over fifty-two million years. 
Bats are extremely diverse in terms of habitats -- they are distributed over all continents except the polar regions -- diets -- insectivorous, carnivorous, frugivorous, nectariferous, piscivorous and even sanguinivorous -- and other traits.  
One of their most distinctive features is their capacity for hosting and transmitting pathogens such as zoonotic viruses.
Bats have been considered hyper-reservoirs based on the hypothesis that they disproportionately host viruses @luis_comparison_2013, although recent work suggests their high viral richness instead reflects the speciose nature of this order and substantial sampling effects @mollentze_viral_2020 @albery_urban-adapted_2022. 
However, bats do host many zoonotic viruses without showing disease, which likely reflects distinct immune adaptations @chan_interspecies_2013@irving_lessons_2021@nabi_bats_2021. 
The immune system of bats has often been studied as a monolith, whereas recent studies demonstrate great immunological diversity among families and even within genera. 
#cite(<becker_2025>, form: "prose") have highlighted how the diversity of traits within this order is linked to diversity and heterogeneity in immune responses. 
In addition, certain ecological traits such as large range area, diet diversity, high population densities, longevity and spatial mobility may predispose bats to hosting and transmitting pathogens @olival_host_2017 @albery_urban-adapted_2022@chan_interspecies_2013. 
This suggests that traits are key factors as to why bats play such an important role as hosts of zoonotic viruses. 
In that sense, we can expect that the importance and the diversity of traits are linked to diverse immunological responses among bat species, thereby enabling multiple ways for a bat to serve as a host for zoonotic viruses.

Trait-based machine learning (ML) models are highly predictive of the zoonotic status of mammal hosts @olival_host_2017 @han_rodent_2015 @han_undiscovered_2016. 
They function by learning patterns inherent in hosting status to identify the trait profile and predict potential host species based on their suitability to fit the trait profile of known hosts. 
Macroecological features, such as geographical range area and range limits, and intrinsic traits associated with reproductive outputs, have been key predictors of the zoonotic status of rodents @han_rodent_2015, primates @han_confronting_2019, and bats @han_undiscovered_2016. 
In a recent study, #cite(<becker_optimising_2022>, form: "prose") developed an ensemble of eight models, including four network-based models, three trait-based models, and one hybrid model, to predict host-virus interactions. Each of these models generated a list of bat species that are potential hosts for betacoronaviruses, to then provide sampling recommendations for novel hosts and virus discovery. 
The entire pipeline was repeated a year later using the most recent data on the detection of new betacoronavirus host species. With improved performance, the revised ensemble model predicted more than 400 potential undetected bat hosts of betacoronaviruses. 
Such method provides valuable information to guide biodiversity surveillance and wildlife disease monitoring @Poisot_fellow, as it highlights species that represent high-priority targets for empirical evaluation @Juman_. 

However, predictions returned by these models often lack epistemic transparency in the sense that we know what the model predicts, but we don't understand which particular features are influencing the predictions. 
Although some proposals based on _e.g._ dimensionality reduction through embedding @Strydom suggest that we can draw correlative explanations from predictive models, they still fall short of providing easily interpretable justifications for individual predictions. 
This is a strong limitation to the adoption of model-based predictions of zoonotic risk @carlson_future_2021, as stakeholders typically lend more credibility to data coming from measurements @turnhout_measurementality_2014 and are less likely to rely on scenarios with low transparency even when they lead to positive outcomes @weiskopf_increasing_2022. 
The lack of epistemic transparency in ML causes two major limitations: predictions can be difficult to trust and to translate into action, and the results do not imply any connection between the the ecology of hosts and their ability to carry zoonotic pathogens.

Explainable ML is emerging as a series of methodological practices that generate more interpretable models and model outcomes, with demonstrated potential to improve adoption of these models amongst policymakers @amarasinghe_explainable_2023. 
As suggested by @adadi_peeking_2018 @molnar2025, interpretability in the context of ML enables researchers to achieve three main goals, or at least make progress towards: improvement and control of the model, justification of the model and its predictions, and insights discovery. 
We here focus on justification and discovery. 
The goal of interpreting and justifying predictions given by a ML model is to increase credibility towards stakeholders, particularly decision-makers, and gain trust. 
Another key use of explainable ML is to explore and discover unexpected relationships between the features and the predictions. 
Since a ML model learns patterns inherent in the data, this can be used to explore previously unknown or unexpected relationships and underlying mechanisms that would challenge and possibly improve domain knowledge. 
To do this, one must be able to extract the information learned by the model.

This study aims to provide easily interpretable justifications of the zoonotic status of bats as hosts of betacoronaviruses at three distinct phylogenetic scales: order, family, and species.
More precisely, we want to provide explanations as to _why_ predictions are reached by analyzing how traits used as predictors contribute quantitatively. 
We hypothesize that geographical features, _e.g_ range area and range limits, and traits linked to reproductive output will contribute to predicting bat hosts of betacoronaviruses, as these traits have been previously linked to predicting bat hosts of filoviruses @han_undiscovered_2016. 
The complexity of ecological systems—in this case, the interactions between hosts and viruses—requires a multiscale approach, as different phylogenetic levels are thought to be governed by different biological mechanisms @Graham_Storch_Machac_2018. 
In this regard, we propose to highlight how key predictors of the betacoronavirus-positive status can differ from one bat family to another (interfamily), as well as within families themselves (intrafamily).
This study also aims to discover insights by extracting learned information from a translucent predictive model that may yield unexpected underlying mechanistic processes governing host-virus interactions. 
In other words, this is a diagnostic approach in which we use an already trained model to examine its behavior rather than the predictions it makes. 
Our goal is to understand what the model has learned about the ecology of host-virus interactions during its training process. 
Within our case study of bats and betacoronaviruses, we aim to better understand the mechanistic causes that make bats such important hosts, in some cases reservoirs, of highly pathogenic viruses, especially how bat traits, and diversity thereof, are key factors in host-virus interactions @cummings_viral_2025.



= Methods
In this study, we trained a trait-based ML model to predict the host status of bat species (_i.e._, the label) based on their trait profiles. 
The model was trained on a large corpus of intrinsic and extrinsic traits (_i.e._, the features). 
Once the model was trained, we computed Shapley values (SV) to quantify the contribution of each input trait. 
All analyses in this study were conducted using primarily MLJ.jl v0.20.9 @Blaom2020 and ShapML.jl v0.3.2 @redell2020shapml on Julia v1.11 @Julia-2017, with the code and data available on GitHub (*link*).


== Host-virus interaction data
The host-virus interaction data used here were collected from the VIRION database compiled by the Verena Institute @carlson_global_2022. 
VIRION contains records of empirically collected interactions of vertebrate hosts and viruses compiled from many databases and scientific literature into a common database that automatically updates with new data. 
For this analysis, we used the available data as of August 25th 2025 and filtered it to host order Chiroptera and virus genus _Betacoronavirus_. 
We removed records for which the hosts were not specified at the species level, leaving us with 92 bat species known as hosts of betacoronaviruses. 
None of these host species were labeled as positive solely through serology; therefore, it was not necessary to filter by detection methods. 
These interaction data are by definition presence only, thus the dataset does not include non-hosts. 
For this analysis, we considered all species not tracked as known hosts in VIRION, within our feature data (since VIRION by definition would not have those species), to be unknown hosts of betacoronaviruses, creating pseudo-absences as opposed to having true absences data. 
The 92 species known to be hosts of betacoronaviruses were assigned binary value 1 (presence of virus interaction). 
The final output of our host-virus interaction dataset is thus a list of bat species known to be hosts of betacoronaviruses, along with the binary value associated with their positive status. 


== Trait data
As predictors of our model, we used species traits from the COMBINE database @soria_combine_2021, a publicly available dataset built from an extensive review of published mammal trait sources between 1999 and 2020. 
It originally contained 54 intrinsic and extrinsic traits providing useful information on morphology, reproduction, diet, biogeography, life habit, phenology, behavior, home range, and density for 1,342 bat species. 
COMBINE has the useful feature of imputing missing data for non-biogeographical traits that already have 20% or more of existing data, which makes it more complete than other traits databases such as PanTHERIA @jones_pantheria_2009 or EltonTraits @wilman_eltontraits_2014. 
Trait data often suffer similar sampling biases as interaction data, especially for bats, which makes it challenging to find useable information for certain traits such as life-history. 
The COMBINE data imputation process in part helps to overcome the availability issues associated with this type of data. 
For a more complete set of predictors, we also added 15 variables on geographical range, climatic conditions, and human population densities from the PanTHERIA database (which covers 1,116 bat species), because these variables seem particularly predictive of host-virus interactions @becker_optimising_2022 @han_undiscovered_2016 @olival_host_2017. 
We also added the bat family as an input feature to test the likelihood of clustering among host species @han_undiscovered_2016. 

== Taxonomic reconciliation 
When initially merging the interaction dataset with the trait dataset, nine records from the interaction dataset were left with no match in the trait dataset, as the species names in the latter were not updated as they were in interaction dataset. 
We then manually reconciled these species names following the taxonomies of the IUCN Red List @iucn to update the trait dataset and make sure all hosts species in the interaction data had a correct match in the trait data @gibb_data_2021. 
We also removed extinct species (seven records in the trait dataset) as well as _sp._ and sub species (10 records in the interaction dataset) that were currently not recognised by the taxonomies of the IUCN Red List. 
All the species that were not in the interaction dataset -- that had no published record of interacting with betacoronaviruses -- were assigned binary value 0 and identified as unknown hosts, meaning they will be considered as non-interacting with betacoronaviruses within the machine learning process. 
Our merged interaction-trait dataset covered 1,335 bat species, 92 of which are known hosts, across 20 families (@sup1).   

== Data cleaning and imputation

In order to avoid data leakage by overloading the model with duplicate information, we excluded redundant features from COMBINE that provide very similar information: we removed diet data from EltonTraits to prioritize diet data from PHYLACINE @phylacine as the latter had higher coverage, thus needing less additional data imputation. 
We applied two exclusion criteria for the trait data: baseline coverage and variation threshold. 
For the baseline coverage, we excluded any traits that greater than 50% of missing values @becker_optimising_2022, which mostly impacted life history variables, since these data are particularly sparse for wildlife species. 
For the variation threshold, we excluded traits that had more than 97% homogeneity @becker_optimising_2022. 
This ensured that no variable that is homogeneous to almost all bat species is used in model training, therefore optimizing the classification process. 
The 50% baseline coverage and the 97% homogeneity thresholds were determined partly by drawing on those used in #cite(<becker_optimising_2022>, form: "prose") and partly by testing stricter and less strict thresholds, neither of which improved the model's performance. 
Remaining missing values in numeric variables were imputed by the median of the family, whereas missing values in categorical variables were replaced by the mode of the family. 
Two families (Cistugidae and Mystacinidae), both only containing two species, had only missing values for a small amount of traits - which we imputed with the median of all species instead of the median of the family. 
The cleaned dataset contained 1,335 bat species, 45 associated traits, and the host status (known or unknown) represented by a binary value. 


== Model training 
One of the most predictive models from #cite(<becker_optimising_2022>, form: "prose") was a boosted regression trees algorithm (BRT) that combines regression trees -- models that use binary splits to establish relationships between a response and the predictors -- and boosting -- a method that combines multiple simple models to improve performance @elith_working_2008. 
We ported this model to the MLJ.jl @Blaom2020  and EvoTrees.jl @jeremie_desgagne_bouchard_2026_18753704 packages on Julia 1.11. 
To put it simply, the BRT algorithm performs binary classification on the cleaned dataset - predicting host status based on the traits of each species. 

To tune the model, we optimized its classification threshold, which means optimizing the threshold value at which the probability of the positive class is considered a positive prediction (host species). 
Since our data contained significant class imbalance (92 presence data points versus 1,243 pseudo-absence data points), optimizing the threshold tends to a more predictive model that will not just simply guess the most common class. 
To do so, we wrapped our inital classifier (BRT) in a binary threshold predictor that evaluates the performance of 30 meta-models, each with a different threshold value, between 0 and 1. 
The optimal threshold (τ ≈ 0.088) was used to make class predictions on the whole dataset. 


== Model validation
To assess the performance of the model, we used leave-one-out cross-validation (LOOCV), a process during which data is split into training and testing sets multiple times, called folds, so that the model is trained with training data and is evaluated with testing data. 
For LOOCV, each fold contains a training set of _n_-1 instances, which leaves one instance for the testing set. 
The folding process is repeated until all of the instances have been used separately in the testing set. 
The model is trained on every fold, which means that every single instance is used at some point in the process to train the model, making it an exhaustive method for doing cross-validation.

The Matthews correlation coefficient (MCC) was used to measure the performance of the model as it has been identified as the most appropriate measure @chicco_matthews_2023, because it is optimized only when the model achieves a good score in each of the four quadrants of the confusion matrix—that is, when the model performs well at everything. 
The coefficient is a value between -1 (the predictions are opposite to the actual values) and +1 (the predictions are perfectly accurate), where zero represents random predictions. 
For our study, we report an MCC of 0.399, which means that our model performs better than random predictions. 
Since our goal is to study the model's behavior rather than the accuracy of its predictions, we consider this MCC to be satisfactory.  

== Shapley values
In an explainable ML approach, SV are post-hoc explanations, meaning they are computed once the model is trained and predictions have been generated. Originally, SV were developed for coalition game theory to assign each player of a coalition an importance score that quantifies its contribution to the game payout @Roth1988-wb. 
In our case, the game payout corresponds to an actual prediction, minus the average prediction, and each player are input features that led to this prediction. 
SV quantify each input feature’s contribution to moving the actual prediction from the average prediction @wadoux_shapley_2023. 
In other words, this method allows us to quantify, for each species, the contribution of the traits that led to the known host or unknown host prediction. 
SV were computed using ShapML.jl v0.3.2 for Julia with a Monte-Carlo sample size of _n_ = 500. 

Once computed, we first used SV to rank the most important traits as predictors of the host status of bats for betacoronaviruses by calculating the mean of the absolute SV per trait for known and unknown hosts. 
We used scatterplots to visualize individual data-points for the most predictive features and assess trends. 
Then, we ranked the most important traits per bat family to assess taxonomic-specific trends. 
To do so, we focused our analyses on families that contained three or more betacoronavirus-positive species in the VIRION database as of August 25th 2025 (Vespertilionidae, Rhinolophidae, Pteropodidae, Phyllostomidae, Molossidae, Mormoopidae and Hipposideridae; @sup1) and on features whose contributions add up to 75% of total contribution for known hosts. 
Finally, we used species-level SV to compare inter- and intra-family trends. 
For the inter-family comparison, we picked the species with the largest range area belonging to each of the selected families. 
For the intra-family comparison, we selected the seven species with the largest range belonging to the family Vespertilionidae, since this is the family with the greatest number of species @soria_combine_2021.

= Results and discussion 

== Global drivers of  predictions for bat-betacoronaviruses interactions
In @total, we present the global importance, represented by mean SV, of each trait to the predictions made by the ML model. 
The most important predictor of betacoronavirus hosting status is geographic range area, followed by maximum latitude and mean human population density. These three features are the most important, although to varying degrees, both in known hosts and unknown hosts.
They stand out particularly from the other features with respective contributions of around 17%, 12%, and 10%, accounting for 39% of the total contribution.
The fourth most important variable (maximum longitude) contributes only around 5%, and thereafter we observe a steady decline in contributions down to zero.
The thirteen most important features for hosts account for around 75% of the total contribution and were used for further analysis.
A similar pattern is observed in the contributions of unknown host species, although the SV are of smaller magnitude.
The reason only a small fraction of features account for a high proportion of total contribution can be explained by the way SV will boost the most informative features.
The top three features probably add a lot of information as predictors, whereas the other features add less information or none at all. 

#figure(
  image("figures/aug_shap.png", width: 80%),
  caption: [*Mean of absolute SV for each feature grouped by status.* For each species, the BRT model predicted probabilities for each of the two possible classes (0 indicating the absence of the virus, 1 indicating the presence of the virus). SV were calculated based on the probability of the positive class. Each trait for each species was assigned a SV that quantifies its contribution to the prediction. To better illustrate this, we used the absolute SV to calculate the average by actual status (as opposed to predicted status): known hosts and unknown hosts.]
) <total>

These results highlight the importance of biogeographical features, specifically range area and range limits, as predictors of hosts of betacoronaviruses.
@trois shows how a larger geographic range area corresponds to higher SV, which means that larger areas contribute more importantly to the predictions.
From an ecological standpoint, a larger area could increase encounters with other species and thus increase risks of transmission and exposure to pathogens @Guy_Ratcliffe_Mideo_2020 @Lindenfors_Nunn_Jones_Cunningham_Sechrest_Gittleman_2007.
A recent study highlighted that larger range size predicts higher viral diversity in bat species @becker_2025, which also underscores the importance of range area as a key factor in determining the viral status of bats.
We observe that maximum latitude values greater than 25°N are associated with higher SV, whereas those less than 25°N tend toward zero (@trois).
We expected that maximum latitudes reflecting relatively southern distribution ranges would contribute significantly -- based on predictions of increased new interactions in the Amazon and new mammal hosts in Africa @poisot_network_2023 -- but it turned out to be the opposite.
The highest SV correspond to maximum latitudes between 25°N and 75°N and maximum longitudes between 60°E and 130°E (@trois), suggesting that these species range primarily in Europe and Asia, including a cluster in Eastern Asia.
This result shows that range limits (maximum latitude and maximum longitude) located in Europe and Asia, particularly in China, are important predictors of bat hosts of betacoronaviruses.
China is home to more than 100 species of bats, some of which are endemic, with many betacoronaviruses circulating @wacharapluesadee_evidence_2021 @latinne_origin_2024.
Both SARS-CoV and SARS-CoV-2 likely derived from related bat-borne sarbecoviruses circulating in Southeast Asian bats @worobey_huanan_2022.
The high diversity of bat betacoronaviruses circulating in China is likely the result of a long coevolutionary history @Ruiz-Aravena.
However, sampling efforts have been very high in China since the emergence of SARS-CoV in 2002, potentially leading to disproportionate sampling and targeting of known betacoronavirus hosts @cohen_coronavirus_2023.
This sampling bias could therefore inflate the SV in this region. 
It is also important to note the sampling biases emerging from collecting data on host-virus interactions. 
Sampling efforts in bats appear to be disproportional towards easily captured species, in specific regions and habitats of high species richness @zamora-gutierrez_spatial_2019, and in countries with ongoing research programs focusing on bat-pathogen sampling @juman_paramyxoviruses_2025, which all could lead to inflating SV for geographical features.


#figure(
  image("figures/A.png", width: 90%),
  caption: [*A.* Relationship between SV and the range area value for each species. The gray points represent species that are unknown hosts, while the blue points represent species that are known hosts. *B.* Maximum latitude and mid longitude limits of range for each species and associated SV. Pink color represent lower SV, whereas blue represent higher SV. *C.* Relationship between SV and the mean population density value for each species. The gray points represent species that are unknown hosts, while the blue points represent species that are known hosts.]
) <trois>


Mean human population density is the third most important predictor in our model.
Figure 2 shows that higher human population densities are linked with higher SV in host species.
Global changes like land-use conversion happening in highly populated regions have been linked to increased interfaces between humans, lifestock and wildlife reservoirs of zoonotic diseases @gibb_zoonotic_2020 @Gibb_2024.
Parasite diversity in hosts more broadly follows a rural-urban gradient in which diversity is greater in hosts species in urban environments, likely caused by weakened immunity due to pollution and altered nutrition and higher hosts densities @Murray_2019.
Certain ecological or life-history traits may influence both host status and the ability to adapt to human disturbances @Johnson_2012 @Johnson_Preston_Hoverman_Richgels_2013, leading to trends of mammals species with higher pathogens richness more likely to occur in human-managed areas @gibb_zoonotic_2020.
The importance of higher human population densities as a predictor of host status (@trois) also probably recaptures sampling bias arising from proximity to humans @albery_urban-adapted_2022.  


== Hosting at the family scale
We found that there are various ways to serve as a host for betacoronaviruses across phylogenetic scales, and that the family-level scale shows how traits that are specific to a certain family also tends to become its most important predictors.
As shown in @facet, some traits such as range area, adult body mass, and interbirth interval contribute differently depending on the family.
However, some other traits contribute in a similar way across families, _e.g._ habitat breadth, which can be unexpected considering that habitat breadth is usually linked to geographic range size.
One might think that the contribution of habitat breadth would be similar as that of the range size, since a larger geographic range might result in occupying more different habitats @Lindenfors_Nunn_Jones_Cunningham_Sechrest_Gittleman_2007.
However, SV tend to boost the most informative features, here range area, whereas habitat breadth likely does not add more information.
The family-specific traits that stand out the most are range area for the Molossidae, adult body mass and forearm length for the Pteropodidae, and interbirth interval for the Phyllostomidae.
Families with a small number of host species, such as the Molossidae and the Phyllostomidae, can stand out more easily from the global average.
In contrast, the Vespertilionidae, a family with a large number of host species, do not have traits whose contribution are particularly distinct or high. 

#figure(
  image("figures/aug_shap_hosts.png", width: 80%),
  caption: [*Mean SV of the selected features to predictions of host species grouped by family*. The selected features are those whose contributions account for 75% of the total contributions. We selected the families that contained three or more host species: Vespertilionidae, Rhinolophidae, Pteropodidae, Phyllostomidae, Mormoopidae, Molossidae, and Hipposideridae. The total contribution (dark blue) represents the average for all hosts species (_n_ = 92) belonging to any of the 20 families included in the initial dataset. ]
) <facet>

Range area plays an important role as predictor for hosts species within the Molossidae family with a mean of absolute SV of 0.285 (SE 0.059) compared to the global mean of 0.139 (SE 0.010).
There appears to be a trend of larger range areas among molossid that are hosts of betacoronaviruses than among other families and unknown hosts (@sup2), but the small number of host species limits our analyses and could simply introduce a bias.
Within the four molossids hosts, only two species present significantly higher SV: _Molossus molossus_ and _Mops condylurus_ respectively have SV of 0.39 and 0.38.
The two other host species (_Mops plicatus_ and _Tadaria brasiliensis_) have SV that are close to the overall average.
Although there is indeed a relationship between range size and the SV (@trois), it is hard to conclude if this relationship is any more distinct or stronger in the Molossidae than in other families.

Another interesting case is the contribution of body mass to predictions of host species within the Pteropodidae family, where the average SV is 0.099 (SE 0.014), compared to the global average of 0.031 (SE 0.005). 
@bodymass shows a clear trend of higher SV linked to higher body mass values for host species, where pteropodids stand out particularly with their important body mass values.
Overall, we observe that SV increase when the logarithm of body mass is greater than four; below this value, SV tend to plateau toward zero. Forearm length also contributes distinctly for the Pteropodidae, whereas body length contributes little (@facet).
Members of the Pteropodidae family are known to be the largest species of bats, some of which can weigh up to 1500 g and have a wingspan of up to 1.8 meters @Nowak_1994, which is likely the result of character displacement in islands @Almeida.
As opposed to large birds and non-flying mammals, bat immune cell proportions do not vary systematically with body mass, therefore not supporting the hypothesis that the evolution of flight enabled a relationship between body mass and immunity @CorneliusRuhs_2021.
The morphological traits of the Pteropodidae are highly specific and distinct from other families, and they appear to be key factors in explaining why these species are hosting betacoronaviruses.   

#figure(
  image("figures/aug_bodymass_hosts_fams.png", width: 60%),
  caption: [*Relationship between SV and body mass values for species hosts of betacoronaviruses.* The different colors represent the families, selected based on the number of species they contain: Vespertilionidae, Rhinolophidae, Pteropodidae, Phyllostomidae, Molossidae, Mormoopidae and Hipposideridae. Each dot represents a species known to be host of betacoronaviruses.]
)<bodymass>
 

Interbirth interval is the most important predictor for host species within the Phyllostomidae with an average Shapley value of 0.103 (SE 0.012) which is more than double the values for the other families and the overall average of 0.023 (SE 0.003).
In @birth, we show that shorter interbirth interval, mainly observed for the Phyllostomidae and Pteropodidae, increases the SV.
The Phyllostomidae and Pteropodidae have the shortest average interbirth interval @soria_combine_2021, and although other phyllostomid and pteropodid species have short interbirth intervals, SV are distinctly high only in hosts, suggesting that this mechanism is status-specific. 
#cite(<han_undiscovered_2016>, form: "prose") identified lifetime reproductive output as a key predictor of bat reservoir of filoviruses. Shorter birth intervals had also been observed in primates that are hosts of Zika virus compared to non-hosts @han_confronting_2019. 
On the one hand, investing in reproduction may require compromising immunity, thereby increasing the chances of becoming hosts @Lochmiller_Deerenberg_2000. 
On the other hand, shorter interbirth interval increases the proportion of time spent in maternity roosts each year and, consequently, the risk of transmission under both density- and frequency-dependent transmission scenarios, since the likelihood of viral transmission through a more rapid replacement of vulnerable pups is increased with biannual births @Amman_2012 @Hayman_2015.
Thus, shorter birth intervals appear to be an important determinant of host status in bats, especially for phyllostomids. 


#figure(
  image("figures/aug_birth_hosts.png", width: 60%),
  caption: [*Relationship between SV and interbirth interval values for species hosts of betacoronaviruses* The different colors represent the families, selected based on the number of species they contain: Vespertilionidae, Rhinolophidae, Pteropodidae, Phyllostomidae, Molossidae, Mormoopidae and Hipposideridae. Each dot represents a species known to be host of betacoronaviruses.]
)<birth>

== Hosting at the species scale
One of the most interesting properties of SV is their ability to explain an individual prediction.
Here, we seek to understand what makes bat species host betacoronaviruses and how this varies from one to another.
@ens shows variations in traits contribution among species, at both the inter-family and intra-family scales.
As expected, species from different families have different SV and exhibit patterns similar to those seen in the family-level analysis: *a)* interbirth interval is important for the species within the  family Phyllostomidae, *b)* the family feature contributes highly for the mormoopid species and the rhinolophid species and *c)* range size, maximum latitude and human population density are overall highly predictive of bat hosts.
On the other hand, body mass does not play a significant role in predicting the status of the pteropodid species. 

The marked variation among species within the same family (here Vespertilionidae) highlights how interspecific variation manifests to affect ability to host, and possibly to transmit, viruses.
This result shows that even species within the same family—that share a stronger phylogenetic relationship and similar traits—have different SV, meaning that different features contributed to making the individual predictions.
During the training process, the model learned that there is interspecific variation in traits and that different traits can lead to a positive prediction.
Our results emphasize how the interspecific trait diversity among chiropterans leads to heterogeneity in immunology across this taxa and shows the various ways there are to be a host of betacoronaviruses @becker_2025.
Different species mean different traits mean different ways to host.
As conceptualized by #cite(<Graham_Storch_Machac_2018>, form: "prose"), the specific properties of a biological system and the attributes to be studied should guide the choice of phylogenetic scale and measure to be used.
Our results demonstrate how important it is to study the ecology of bat hosts at various phylogenetic scales in order to gain a better understanding of the interactions between bats and viruses and as to what makes bat species such important hosts and even reservoirs.

#figure(
  image("figures/interspecific_variation.png", width: 80%),
  caption: [*Comparison of interspecific variation in SV, both inter-family and intra-family.* Inter-family (the species with the largest range area for each of the targeted families): _Myotis laniger_ (Vespertilionidae), _Rhinolophus malayanus_ (Rhinolophidae), _Epomophorus pusillus_ (Pteropodidae), _Glossophaga leachii_ (Phyllostomidae), _Mops plicatus_ (Molossidae), _Pteronotus parnellii_ (Mormoopidae), _Hipposideros ruber_ (Hipposideridae). Intra-family (the seven species with the largest range area belonging to the family of Vespertilionidae) : _Myotis laniger_, _Pipistrellus pipistrellus_, _Cnephaeus serotinus_, _Vespertilio sinensis_, _Kerivoula furva_, _Submyotodon latirostris_, _Myotis davidii_.]
) <ens>


= Conclusion 
We demonstrated how SV, a post-hoc method of explainable machine learning, can be used to interpret individual predictions and also how they can be used to have a better understanding of global, family-level and species-level importance of input features.
We used SV not only as a way to quantify the importance of traits to predictions, but also as an exploratory approach to investigate unknown or unexpected relationships between traits and host status.
Our results demonstrate there are various ways to serve as a bat host of betacoronaviruses across phylogenetic scales (global, family, species), and each of these scales show a different pattern.
At the global scale, range area, maximum range limits, and human population density are the most important predictors of host species.
This allows us to identify key predictors at the macroecological scale, which underscores the previously highlighted importance of the biogeography of bat hosts of betacoronaviruses @forero-munoz_coevolutionary_2024.
At the family level, the variation in SV seem to recapture the distinctive characteristics specific to certain families. 
Intrinsic features such as morphology (_i.e.,_ body mass for pteropodids) and life-history traits (_i.e.,_ interbirth interval for phyllostomids) gain importance as predictors.
At the species level, there is a marked variation in SV both among species from different families and among species within the same family.
All kind of traits have the potential to become important predictors.
In this study, we showed that traits, and the diversity thereof, are important predictors of bat hosts of betacoronaviruses and that they are key factors as to why so many different species can serve as hosts.
Traits are important features that recapture evolutionary history underlying the abilities of many bat species to serve as hosts of zoonotic viruses @han_undiscovered_2016.

Each of these scales also seems to recapture existing sampling phylogenetic or geographic biases.
Due to their reliance on ecological traits, environmental covariates, and phylogenetic relationships, trait-based models tend to reflect spatial and phylogenetic trends @becker_optimising_2022.
At the global scale, the most predictive features (range area, maximum latitude and human population density) appear to be closely linked to geographic sampling biases and to proximity to areas of high population density @cohen_coronavirus_2023 @albery_urban-adapted_2022.
When looking at SV by family, we risk to recapture phylogenetic sampling biases.
For example, the model learned that belonging to the Mormoopidae family is a significant predictor of host status for species within that family, which is likely a bias resulting from the small number of species in that family and the high ratio of hosts and unknown hosts.
Nonetheless, this result demonstrates the model’s ability to effectively capture trends during training and to highlight them when making predicting host status of bats. 

Our approach has demonstrated the usefulness of SV as a post-hoc, model-agnostic method for interpreting individual predictions.
This method can easily be applied to models that have already been trained and can also be used on new samples, making it very efficient and versatile to improve the transparency of ML models. 

= Acknowledgments 

We acknowledge that this study was conducted on land within the traditional unceded territory of the Saint Lawrence Iroquoian, Anishinabewaki, Mohawk, Huron-Wendat, and Omàmiwininiwak nations. MH was founded through (...)

#showbibliography("reference_april.bib")

#pagebreak()

= Supplementary material 

#set figure(
  kind: "supplement",
  supplement: [Figure],
  numbering: n => [S#n]
)

#figure(
  image("figures/aug_supp1.png"),
  caption: [Number of unkown host species (gray) and known host species (blue) per family. The families with three or more known host species are used for the family-level analyses.]
)<sup1>

#figure(
  image("figures/aug_boxplot_status.png"),
  caption: [Geographic range area by family (represented by different colors) and by status (for a given family, the box on the left represents the unknown hosts and the one on the right the known hosts). We see that range area tends to be larger for hosts belonging to the Molossidae family.]
)<sup2>
