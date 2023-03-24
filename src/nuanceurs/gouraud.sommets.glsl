#version 410

// Définition des paramètres des sources de lumière
layout (std140) uniform LightSourceParameters
{
    vec4 ambient[3];
    vec4 diffuse[3];
    vec4 specular[3];
    vec4 position[3];      // dans le repère du monde
    vec3 spotDirection[3]; // dans le repère du monde
    float spotExponent;
    float spotAngleOuverture; // ([0.0,90.0] ou 180.0)
    float constantAttenuation;
    float linearAttenuation;
    float quadraticAttenuation;
} LightSource;

// Définition des paramètres des matériaux
layout (std140) uniform MaterialParameters
{
    vec4 emission;
    vec4 ambient;
    vec4 diffuse;
    vec4 specular;
    float shininess;
} FrontMaterial;

// Définition des paramètres globaux du modèle de lumière
layout (std140) uniform LightModelParameters
{
    vec4 ambient;       // couleur ambiante globale
    bool twoSide;       // éclairage sur les deux côtés ou un seul?
} LightModel;

layout (std140) uniform varsUnif
{
    // partie 1: illumination
    int typeIllumination;     // 0:Gouraud, 1:Phong
    bool utiliseSpot;         // indique si on utilise des lumière de type spot ou point
    bool utiliseBlinn;        // indique si on veut utiliser modèle spéculaire de Blinn ou Phong
    bool utiliseDirect;       // indique si on utilise un spot style Direct3D ou OpenGL
    bool afficheNormales;     // indique si on utilise les normales comme couleurs (utile pour le débogage)
    // partie 2: texture
    float tempsGlissement;    // temps de glissement
    int iTexCoul;             // numéro de la texture de couleurs appliquée
    // partie 3b: texture
    int iTexNorm;             // numéro de la texture de normales appliquée
};

uniform mat4 matrModel;
uniform mat4 matrVisu;
uniform mat4 matrProj;
uniform mat3 matrNormale;

/////////////////////////////////////////////////////////////////

layout(location=0) in vec4 Vertex;
layout(location=2) in vec3 Normal;
layout(location=8) in vec4 TexCoord;

out Attribs {
    vec4 couleur;
} AttribsOut;


float calculerSpot( in vec3 D, in vec3 L, in vec3 N )
{
    float spotFacteur = 0.0;
    if ( dot( D, N ) >= 0 )
    {
        float spotDot = dot( L, D );
        if ( spotDot > cos(radians(LightSource.spotAngleOuverture)) ) 
        {
            if (utiliseDirect) 
            {
                spotFacteur = smoothstep
                (
                pow(cos(radians(LightSource.spotAngleOuverture)),1.01 + LightSource.spotExponent/2), 
                cos(radians(LightSource.spotAngleOuverture)), 
                spotDot
                );
             }
        else 
        {
            spotFacteur = pow( spotDot, LightSource.spotExponent );
        }
    }
    return( spotFacteur );
    }
}

float attenuation = 1.0;
vec4 calculerReflexion( in int j, in vec3 L, in vec3 N, in vec3 O ) // pour la lumière j
{
    vec4 coul = vec4(0);

    // calculer l'éclairage seulement si le produit scalaire est positif
    float NdotL = max( 0.0, dot( N, L ) );
    if ( NdotL > 0.0 )
    {
        // calculer la composante diffuse
        coul += attenuation * FrontMaterial.diffuse * LightSource.diffuse[j] * NdotL;

        // calculer la composante spéculaire (Blinn ou Phong : spec = BdotN ou RdotO )
        float spec = ( utiliseBlinn ?
                       dot( normalize( L + O ), N ) : // dot( B, N )
                       dot( reflect( -L, N ), O ) ); // dot( R, O )
        if ( spec > 0 ) coul += attenuation * FrontMaterial.specular * LightSource.specular[j] * pow( spec, FrontMaterial.shininess );
    }

    return( coul );
}

void main( void )
{
    // appliquer la transformation standard du sommet (P * V * M * sommet)
    gl_Position = matrProj * matrVisu * matrModel * Vertex;

<<<<<<< Updated upstream


=======
>>>>>>> Stashed changes
    // calculer la normale (N) qui sera interpolée pour le nuanceur de fragments
    vec3 N = normalize(matrNormale * Normal);

    // calculer la position (P) du sommet (dans le repère de la caméra)
    vec3 pos = vec3( matrVisu * matrModel * Vertex );

<<<<<<< Updated upstream
    // calcul de la composante ambiante du modèle
    vec4 coul = FrontMaterial.emission + FrontMaterial.ambient * LightModel.ambient;

    // calculer le vecteur de la direction (O) vers l'observateur (dans le repère de la caméra)
    // on considère que l'observateur (la caméra) est à l'infini dans la direction (0,0,1)
    vec3 obsVec = (-pos); //vec3( 0.0, 0.0, 1.0 );//(-pos);   // =(0-pos) un vecteur qui pointe vers le (0,0,0), c'est-à-dire vers la caméra
    vec3 O = normalize( obsVec );  // position de l'observateur

    // couleur du sommet
    for (int j = 0; j < 3; j++){

        // calculer le vecteur de la direction (L) de la lumière (dans le repère de la caméra)
        //AttribsOut.lumiDir = ( matrVisu * LightSource.position ).xyz - pos;
        // dans cet exemple, on décide plutôt que la direction (L) de la lumière est déjà dans le repère de la caméra
        vec3 lumiDir = ( matrVisu * LightSource.position[j] ).xyz - pos;
        
        
        vec3 O = normalize( obsVec );
        vec3 L = normalize( lumiDir ); // vecteur vers la source lumineuse

        coul += calculerReflexion( j, L, N, O );
    }
=======
    vec3 obsVec = (-pos); // = (0- pos);
    vec3 O = normalize( obsVec );  // position de l'observateur
    vec4 coul = FrontMaterial.emission + FrontMaterial.ambient * LightModel.ambient;
    vec3 lumiDir;
    vec3 L;
    vec3 D;
    float d;
    for (int i = 0; i < 3; i++) {
    lumiDir = (matrVisu * LightSource.position[i]).xyz - pos;
        L = normalize( lumiDir ); // vecteur vers la source lumineuse
        // calculer la distance de la surface à la source lumineuse
    if (utiliseSpot) {
    d = length( L );
        D = normalize( mat3(matrVisu) * -LightSource.spotDirection[i]); // direction du spot
        // calculer l'atténuation selon la distance à l'objet
         attenuation = min ( 1.0, 1.0 / ( LightSource.constantAttenuation +
                                         LightSource.linearAttenuation * d +
                                         LightSource.quadraticAttenuation * d * d ) );
                                         coul += calculerReflexion( i, L, N, O ) * calculerSpot( D, L, N );
    } 
        else {
       coul += calculerReflexion( i, L, N, O ) ;
       }
        
    }
    
    AttribsOut.texCoord = TexCoord.st + vec2(-1,0) * tempsGlissement;
>>>>>>> Stashed changes
    AttribsOut.couleur = clamp( coul, 0.0, 1.0 );
}
