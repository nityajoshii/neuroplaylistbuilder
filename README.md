Neuro Playlist Builder

A computational neuroscience-inspired music recommendation system built in MATLAB

The project was inspired by learning about visual receptive fields in computational neuroscience and wondering whether a similar computational idea could be applied to music. If visual neurons can be selectively responsive to features such as orientation, motion, and location, could we create a model in which different "neurons" respond preferentially to different combinations of musical features?

Note: This is a MATLAB project exploring how ideas from neuroscience could inspire a music recommendation system and is not biologically accurate. 

What does it do? 

The current version uses a dataset of 86 songs, with each song represented using three simplified musical features:
•	Tempo (BPM)
•	Mode
•	Energy

These features are passed through a simplified emotion-mapping function to generate two psychological dimensions:
•	Valence — broadly representing positive ↔ negative affect
•	Arousal — broadly representing calm ↔ energetic affect

The resulting coordinates are used to classify songs into broad emotional categories based on affective neuroscience:
•	Excited / Joyful
•	Anxious / Agitated
•	Calm / Content
•	Sad / Melancholic

It uses cosine similarity between songs to recommend tracks with similar feature profiles.

Ideation

The central idea came from the concept of a receptive field.
If visual neurons can respond selectively to particular visual features, could a simplified computational model represent different "neural populations" as being tuned to different combinations of musical features?

Thus, I created artificial receptive-field-like units in valence × energy space.

Each artificial neuron has a centre:
Neuron 1 → [valence₁, energy₁]
Neuron 2 → [valence₂, energy₂]
Neuron 3 → [valence₃, energy₃]
...
Neuron 6 → [valence₆, energy₆]

A song activates these neurons according to how close its feature representation is to each neuron's receptive-field centre.

The activation is modelled using a Gaussian function:
activation =
exp(-distance² / (2σ²))

Therefore, a song produces stronger activation in neurons whose receptive-field centres are closer to the song's representation.
This is a computational analogy to receptive-field tuning, not a claim about how individual auditory neurons actually encode music.

From Music → Emotion

The model maps the three input features into an affective space.

Conceptually:
                  Musical Features
                         
        
        ↓                 ↓                 ↓
      Tempo              Mode            Energy                    
       
                         ↓
                  Emotion Mapping
                         ↓
                     ┌───────┐
                      Valence    
                      Arousal    
             
                        ↓
                 Emotional Space
             
The current implementation uses:

Arousal = 0.6 × Energy + 0.4 × Normalized Tempo

Valence = 0.6 × Mode + 0.3 × Energy
          + 0.1 × Normalized Tempo

Note: These equations are approximate but not empirically accurate. 

Artificial Receptive Fields

I used k-means clustering on the songs' valence/arousal representations to create six receptive-field centres.
Each centre can be thought of as an artificial neuron tuned to a particular region of the emotional feature space.
The project visualizes these receptive fields using Gaussian response surfaces.

This allows the user to see:
1.	Where the selected song lies in emotional space.
2.	Which artificial neurons respond most strongly.
3.	How the song's representation relates to other regions of the model's feature space.

Neural Firing Simulation
The model converts receptive-field activation into a simplified "firing strength."

For each artificial neuron:

firing ∝ similarity between
         song representation
         and receptive-field centre

The resulting activity is visualized as a bar chart.

I also created a simple stochastic spike-train simulation which produces a raster plot showing simulated neural firing over time
firing rate → probability of spike → spike times

NOTE: the spikes are synthetic visualizations
 Song Recommendation

The recommendation component currently uses cosine similarity.
Similarity(A,B) =
         A · B
       ───────
       ||A||||B||

The three songs with the highest similarity scores are returned as recommendations.

What I've Learned

1. Complexities of translating a neuroscience concept into a computational model

It requires making explicit assumptions like: 
•	What are the model's input features?
•	What does a "neuron" represent?
•	What determines its preferred stimulus?
•	How strongly should it respond?
•	How should neural activity be visualized?

2. Feature engineering

My current representation:
Song = [Tempo, Mode, Energy]
is extremely small compared with the actual information contained in music.

Real music contains dimensions such as:
•	pitch
•	timbre
•	rhythm
•	harmony
•	melody
•	lyrics
•	vocal characteristics
•	structure
•	familiarity

3. Dimensionality reduction and psychological representations

I learned how a complex stimulus can be represented in a lower-dimensional space.

Here, I reduced musical information into:
Valence × Arousal

This is a useful abstraction, but it is not equivalent to saying that the brain literally represents musical emotion using only two dimensions.

4. Clustering

I used k-means clustering to create receptive-field centres.

5. Similarity-based recommendation

I implemented cosine similarity to compare songs based on their feature vectors.

This taught me how recommendation systems can begin with a relatively simple mathematical question:
"How similar is this item to the user's current target?"

It also made me realize why modern recommendation systems need much richer representations than three manually selected features.

6. The importance of model limitations

The brain's response to music is influenced by:
•	memory
•	culture
•	lyrics
•	personal associations
•	context
•	expectations
•	individual differences

and involves much more than tempo, mode and energy.

Rather than hiding these limitations, I think identifying them is an important part of responsible computational modelling.

Current limitations

•	Only three musical features are used.
•	The valence/arousal representation is an abstraction.
•	The receptive fields are artificial mathematical constructs.
•	Neural firing is simulated rather than biologically modelled.
•	Recommendations are based on feature similarity rather than individual user behaviour.
•	The model does not learn from user feedback.
•	Memory, familiarity, culture and personal associations are not represented.
•	The model does not use real neural recordings.

These limitations are important because real music perception is highly multidimensional and context-dependent.

Disclaimer

This project is an educational and exploratory computational model.
The artificial receptive fields and neural firing simulations should not be interpreted as biologically accurate models of auditory neurons or human music perception.
The purpose of the project is to explore whether concepts from computational neuroscience can provide an alternative way of thinking about music representation and recommendation.
