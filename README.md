# Meta-CrySL

Meta-CrySL is an meta-specification language for CrySL. The main goal is to support reuse and modularization of CrySL specifications. Based on a domain analysis, we found that CrySL specifications might vary according to different perspectives, including:

   * JCA implementation (e.g., JCE provider or Bouncy Castle provider)
   * API implementation version (e.g., Bouncy Castle 1.60 x Bouncy Castle 1.50)
   * Cryptographic standards (e.g., FIPS and EuroCrypt)
   
# Approach

Meta-CrySL is mostly based on meta-programming. We use three different languages: 

   * ECrySL: a slight extension to the original CrySL language
   * Refinement: a language that supports different refinement operations over ECrySL specifications
   * Configuration: a language that puts together ECrySL and Refinement specifications 

We use a program generator infrastructure that takes as input a configuration file and outputs regular CrySL specifications. In this way, we do not have to modify the current crypto analysis of CogniCrypt.
