
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %
 % no.oao.girofaktura 
 % Copyright (C) 2002 Odd Arild Olsen
 %
 % This program is free software; you can redistribute it and/or modify
 % it under the terms of the GNU General Public License as published by
 % the Free Software Foundation; either version 2 of the License, or
 % (at your option) any later version.
 %
 % This program is distributed in the hope that it will be useful,
 % but WITHOUT ANY WARRANTY; without even the implied warranty of
 % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 % GNU General Public License for more details.
 %
 % If you modify this program: Retain the copyright notice and change
 % the file name
 %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


\NeedsTeXFormat{LaTeX2e}[1996/06/01]
\ProvidesClass{no.oao.girofaktura}%

\usepackage[utf8]{inputenc}%
\usepackage[T1]{fontenc}%
\usepackage{graphicx}%
\usepackage{keyval}%
\usepackage{palatino}%
\usepackage{array}%
\usepackage{tabularx}%
\usepackage{ifthen}%
\newcommand\@ptsize{}%

\setlength\paperheight {297mm}%
\setlength\paperwidth  {210mm}%

\renewcommand\@ptsize{2}%
\ProcessOptions
\input{size1\@ptsize.clo}%
\setlength\textwidth{170mm}%
\setlength\textheight{280mm}%
\setlength\lineskip{1\p@}%
\setlength\normallineskip{1\p@}%
\renewcommand\baselinestretch{}%
\setlength\parskip{0em}%
\setlength\parindent{0\p@}%
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setlength\headheight{0\p@}%
\setlength\headsep   {0\p@}%
\setlength\footskip{0\p@}%
\setlength\oddsidemargin{0mm}%
\setlength\evensidemargin{\oddsidemargin}%
\setlength\marginparwidth  {0\p@}%
\setlength\marginparsep {0\p@}%
\setlength\marginparpush{0\p@}%
\setlength\topmargin{0mm}% Her omkring kan du sette inn en dimension for å
% justere vertikal plassering slik at utskriften treffer giroen.
\setlength\voffset{-10.4mm}
\setlength\hoffset{-5.4mm}
\setlength\footnotesep{0\p@}%
\setlength{\skip\footins}{0\p@}%
\setlength\arrayrulewidth{0.4pt}%
\setlength\doublerulesep{2pt}%
\def\ps@empty{%
      \let\@oddfoot\@empty\let\@oddhead\@empty
      \let\@evenfoot\@empty\let\@evenhead\@empty}%

% skriver en artikkeltabellinje: tekst& beløp
\newcommand{\Tabline}[2]{\rule[+1.5ex]{0mm}{1ex}#1&&\mbox{}\hfill#2}%

\newsavebox{\sumbox} % for å beregne bredden på beløpet
\newlength{\artlength} % lengden på artikkelteksten
\newcommand{\artskip}{10mm} % avstand mellom artikkeltekst og beløp
\setlength{\fboxsep}{0mm}   %debugboks rundt elementer
\setlength{\fboxrule}{0.1pt}
%\newcommand{\dbox}{\fbox} % avkomenter denne 
\newcommand{\dbox}{} % og kommenter denne for å få ramme rundt bokser

% Adressat, ferdig boks med passe bredde og høyde. Ikke endre høyde
\newcommand{\ToCompany}[1]{%
  \def\Tocompany{\dbox{\parbox[b][22mm][c]{80mm}{#1}}}}%

% Kundenummer
\newcommand{\CustNo}[1]{\def\Custno{#1}}

% Avsenderadressen, det vil si vårt eget firma. Ferdig boks. Ikke endre høyden
\newcommand{\MyAddress}[1]{%
  \def\Myaddress{\dbox{\parbox[b][22mm][c]{65mm}{#1}}}}%

% deres referanse
\newcommand{\YourRef}[1]{\def\Yourref{#1}}%

%faktura nummeret
\newcommand{\InvoiceNo}[1]{\def\Invoiceno{#1}}%

%Faktura tekst, kan også settes til Kreditnota

\newcommand{\FakturaTekst}[1]{\def\Faktura{#1}}
%faktura dato
\newcommand{\InvoiceDate}[1]{\def\Invoicedate{#1}}%

% Fakturabeløp, dvs nettosum + mva
\newcommand{\SumTot}[2]{% Første arg: kroner, andre: øre
  \sbox{\sumbox}{#1,#2}% Lag en boks av beløpet
  \setlength{\artlength}{\artwidth}% Total tabellbredde
  \addtolength{\artlength}{-\wd\sumbox}%- beløpbredden
  \addtolength{\artlength}{-\artskip}%-avst mellom art og beløp
  \def\Daler{#1}% Øre
  \def\Cent{#2}% Kroner
}%

% Avsendersted som settes før fakturadato
\newcommand{\MyTown}[1]{\def\Mytown{#1}}

% mitt bankkontonummer - sjekk at det er riktig
\newcommand{\MyAccount}[1]{\def\Myaccount{#1}}%

% Betalingsfrist
\newcommand{\LastDate}[1]{\def\Lastdate{#1}}%

% Sidehodet, topp og høyrejusteres. Ikke endre høyden
\newcommand{\HeadMatter}[1]{\def\Header{%
    \parbox[b][42mm][t]{85mm}{\hfill#1}}}%

% Artikkel, første arg: Artikkeltekst andre: beløp
\newcommand{\Article}[2]{\Tabline{#1}{#2}\\}%

% Skriver strek under beløpet
\newcommand{\Divider}{\cline{3-3}}

%Skriver ut summen med to streker under
\newcommand{\Sum}{\Tabline{Sum}{\Daler,\Cent}\\\cline{3-3}\\[-13pt]\cline{3-3}}%

% Sett artikkeltabellens bredde lik bredden på teksten (arkbredde-marger)
\newlength{\artwidth}
\setlength{\artwidth}{\textwidth}
\addtolength{\artwidth}{-1mm}


% Artikkeltabellen. Ikke endre høyden
\newenvironment{Articles}{\vspace{15mm}\\\begin{minipage}[t][90mm][t]{\artwidth}%
  \begin{tabular}[b]{@{}b{\artlength}@{}b{\artskip}@{}b{\wd\sumbox}@{}}
}%
{\end{tabular}\vfill\end{minipage}\vfill%Her kan du legge inn en fottekst
                                % rett over girodelen
}%

% Dette skriver sidehodet. Ikke endre høyden
\newcommand{\InvoiceTop}{\begin{minipage}[t][159mm][t]{\textwidth}%
\dbox{\parbox[t][60mm][t]{\artwidth}{% header, ref, fakturanr, dato
\Tocompany\hfill\Header\\[0mm]
\mbox{}\hfill\textsf{\large 
\Faktura\ \Invoiceno}\\\vfill
\ifx\empty\Yourref\else \Yourref\fi\hfill\Mytown\ \Invoicedate\\[5mm]}}}%


% Her kommer nedre del etter artikkellista. Ikke endre høyder
\newcommand{\InvoiceBottom}{\end{minipage}\\[0mm]%
\dbox{\begin{minipage}[t][102mm][t]{\textwidth}% Girodelen
\dbox{\parbox[t][21mm][t]{\textwidth}{% Kvitteringsstripe
\vspace{13mm}\parbox{50mm}{\hfill\Myaccount}%
\parbox{45mm}{\hfill\Daler,\Cent}\vfill
}}\\[0mm]
\dbox{%
\parbox{\textwidth}{% Betalingsinformasjon
\vspace{3mm}\dbox{\parbox[t][32mm][t]{80mm}{%
\rule{0ex}{1ex}\\\begin{tabular}[t]{@{}b{25mm}@{}b{50mm}@{}}%
\rule{0mm}{2.5ex}%
%\ifx\empty\Custno{}\else{Kunde nr& \Custno\\}\fi
\ifthenelse{\equal{\Custno}{\empty}}{}{Medlemsnr& \Custno\\}%
Faktura nr& \Invoiceno\\
Fakturadato& \Invoicedate\\
\ifx\empty\Lastdate\else Forfall& \Lastdate\fi
\end{tabular}
\vfill}}%
\hfill% bet frist går litt utenfor høyre marg, rlap fjerner feilmelding
\rlap{\hspace{-27mm}\dbox{\parbox[t][5mm][t]{30mm}{\hfill\Lastdate\hfill}}}%
}}
% Til og fra
\Tocompany\hspace{20mm}\Myaddress\vfill
\dbox{% Beløp og kontonummerlinje nederst
\parbox{81mm}{\hfill\textsf{\Daler}}%
\parbox{10mm}{\hfill\textsf{\Cent}}%
\parbox{50mm}{\hfill\textsf{\Myaccount}}}%
\end{minipage}%
}\vfill}%Ferdig


\pagestyle{empty}%
\setlength\parindent{0mm}%

% Defaultverdier
\CustNo{}%
\LastDate{}%
\YourRef{}%
\FakturaTekst{Faktura}%

\endinput
%%
%% End of file `no.oao.girofaktura.cls'.















