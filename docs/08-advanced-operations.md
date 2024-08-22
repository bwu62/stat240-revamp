

# Advanced operations

In this chapter, we will cover a few more advanced, yet incredibly useful data tidying operations like grouping, joining, and pivoting. Along the way, we will also make extensive use of dplyr functions learned in the previous chapter.


## Grouping

Often, you will need to apply dplyr's various operations like `mutate()`, `summarize()`, or slicing function not across the entire dataset but in groups. This is an important technique across data science, whether it's data cleaning to exploration to visualization to modeling.

By default, data frames are not grouped when created or imported. You can create a grouping structure with the `group_by()` function. The basic syntax is `df %>% group_by(col1, col2, ...)` where `col1`, `col2`, ... are variables whose values are used to determine groups. You can group by just 1 variable, 2 variables, or as many variables as needed. **Rows with the same values in the chosen columns will be grouped together**.

After grouping, operations that normally run across all rows **now run across each group**. Here's a few simple examples using the familiar penguins dataset to start:


``` r
# import tidyverse, change theme (optional), and load dataset
library(tidyverse)
source("https://bwu62.github.io/stat240-revamp/ggplot_theme_options.R")
penguins <- read_csv(
  "https://bwu62.github.io/stat240-revamp/data/penguins_complete.csv",
  show_col_types = FALSE
)
```



``` r
# group by species and get mean/median/sd body mass + sample size of each group
penguins %>%
  group_by(species) %>%
  summarize(
    mean_mass   = mean(body_mass_g),
    median_mass = median(body_mass_g),
    sd_mass     = sd(body_mass_g),
    n           = n()
  )
```

```
# A tibble: 3 × 5
  species   mean_mass median_mass sd_mass     n
  <chr>         <dbl>       <dbl>   <dbl> <int>
1 Adelie        3706.        3700    459.   146
2 Chinstrap     3733.        3700    384.    68
3 Gentoo        5092.        5050    501.   119
```

``` r
# we can also group by multiple, e.g. group by spcies + sex
penguins %>%
  group_by(species, sex) %>%
  summarize(
    mean_mass   = mean(body_mass_g),
    median_mass = median(body_mass_g),
    sd_mass     = sd(body_mass_g),
    n           = n()
  )
```

```
# A tibble: 6 × 6
# Groups:   species [3]
  species   sex    mean_mass median_mass sd_mass     n
  <chr>     <chr>      <dbl>       <dbl>   <dbl> <int>
1 Adelie    female     3369.        3400    269.    73
2 Adelie    male       4043.        4000    347.    73
3 Chinstrap female     3527.        3550    285.    34
4 Chinstrap male       3939.        3950    362.    34
5 Gentoo    female     4680.        4700    282.    58
6 Gentoo    male       5485.        5500    313.    61
```

:::{.fold .o}

``` r
# we can of course also mutate within groups
# e.g. convert bill length in mm to number of SDs
#      away from species group mean
# to better show the result, I'm forcing it to print all rows in order
# but hiding the output in a collapsible box for style
penguins %>%
  select(species, sex, bill_length_mm) %>%
  group_by(species) %>%
  mutate(
    n = n(),
    bill_length_std = (bill_length_mm - mean(bill_length_mm)) / sd(bill_length_mm)
  ) %>%
  arrange(species, bill_length_std) %>%
  print(n = Inf)
```

```
# A tibble: 333 × 5
# Groups:   species [3]
    species   sex    bill_length_mm     n bill_length_std
    <chr>     <chr>           <dbl> <int>           <dbl>
  1 Adelie    female           32.1   146        -2.53   
  2 Adelie    female           33.1   146        -2.15   
  3 Adelie    female           33.5   146        -2.00   
  4 Adelie    female           34     146        -1.81   
  5 Adelie    female           34.4   146        -1.66   
  6 Adelie    female           34.5   146        -1.62   
  7 Adelie    male             34.6   146        -1.59   
  8 Adelie    female           34.6   146        -1.59   
  9 Adelie    female           35     146        -1.44   
 10 Adelie    female           35     146        -1.44   
 11 Adelie    male             35.1   146        -1.40   
 12 Adelie    female           35.2   146        -1.36   
 13 Adelie    female           35.3   146        -1.32   
 14 Adelie    female           35.5   146        -1.25   
 15 Adelie    female           35.5   146        -1.25   
 16 Adelie    female           35.6   146        -1.21   
 17 Adelie    female           35.7   146        -1.17   
 18 Adelie    female           35.7   146        -1.17   
 19 Adelie    female           35.7   146        -1.17   
 20 Adelie    female           35.9   146        -1.10   
 21 Adelie    female           35.9   146        -1.10   
 22 Adelie    female           36     146        -1.06   
 23 Adelie    female           36     146        -1.06   
 24 Adelie    female           36     146        -1.06   
 25 Adelie    female           36     146        -1.06   
 26 Adelie    female           36.2   146        -0.985  
 27 Adelie    female           36.2   146        -0.985  
 28 Adelie    female           36.2   146        -0.985  
 29 Adelie    male             36.3   146        -0.948  
 30 Adelie    female           36.4   146        -0.910  
 31 Adelie    female           36.4   146        -0.910  
 32 Adelie    female           36.5   146        -0.873  
 33 Adelie    female           36.5   146        -0.873  
 34 Adelie    female           36.6   146        -0.835  
 35 Adelie    female           36.6   146        -0.835  
 36 Adelie    female           36.7   146        -0.798  
 37 Adelie    female           36.7   146        -0.798  
 38 Adelie    female           36.8   146        -0.760  
 39 Adelie    female           36.9   146        -0.723  
 40 Adelie    female           37     146        -0.685  
 41 Adelie    female           37     146        -0.685  
 42 Adelie    male             37.2   146        -0.610  
 43 Adelie    male             37.2   146        -0.610  
 44 Adelie    female           37.3   146        -0.572  
 45 Adelie    male             37.3   146        -0.572  
 46 Adelie    female           37.3   146        -0.572  
 47 Adelie    male             37.5   146        -0.497  
 48 Adelie    female           37.6   146        -0.460  
 49 Adelie    male             37.6   146        -0.460  
 50 Adelie    female           37.6   146        -0.460  
 51 Adelie    male             37.7   146        -0.422  
 52 Adelie    female           37.7   146        -0.422  
 53 Adelie    male             37.7   146        -0.422  
 54 Adelie    female           37.8   146        -0.385  
 55 Adelie    male             37.8   146        -0.385  
 56 Adelie    male             37.8   146        -0.385  
 57 Adelie    female           37.9   146        -0.347  
 58 Adelie    female           37.9   146        -0.347  
 59 Adelie    female           38.1   146        -0.272  
 60 Adelie    female           38.1   146        -0.272  
 61 Adelie    female           38.1   146        -0.272  
 62 Adelie    female           38.1   146        -0.272  
 63 Adelie    male             38.2   146        -0.234  
 64 Adelie    male             38.2   146        -0.234  
 65 Adelie    male             38.3   146        -0.197  
 66 Adelie    female           38.5   146        -0.122  
 67 Adelie    male             38.6   146        -0.0841 
 68 Adelie    female           38.6   146        -0.0841 
 69 Adelie    female           38.6   146        -0.0841 
 70 Adelie    female           38.7   146        -0.0466 
 71 Adelie    male             38.8   146        -0.00900
 72 Adelie    male             38.8   146        -0.00900
 73 Adelie    female           38.8   146        -0.00900
 74 Adelie    female           38.9   146         0.0286 
 75 Adelie    female           38.9   146         0.0286 
 76 Adelie    female           39     146         0.0661 
 77 Adelie    female           39     146         0.0661 
 78 Adelie    male             39     146         0.0661 
 79 Adelie    male             39.1   146         0.104  
 80 Adelie    male             39.2   146         0.141  
 81 Adelie    male             39.2   146         0.141  
 82 Adelie    male             39.2   146         0.141  
 83 Adelie    male             39.3   146         0.179  
 84 Adelie    female           39.5   146         0.254  
 85 Adelie    female           39.5   146         0.254  
 86 Adelie    female           39.5   146         0.254  
 87 Adelie    male             39.6   146         0.291  
 88 Adelie    female           39.6   146         0.291  
 89 Adelie    female           39.6   146         0.291  
 90 Adelie    male             39.6   146         0.291  
 91 Adelie    female           39.6   146         0.291  
 92 Adelie    male             39.7   146         0.329  
 93 Adelie    male             39.7   146         0.329  
 94 Adelie    female           39.7   146         0.329  
 95 Adelie    male             39.7   146         0.329  
 96 Adelie    male             39.8   146         0.367  
 97 Adelie    male             40.1   146         0.479  
 98 Adelie    female           40.2   146         0.517  
 99 Adelie    male             40.2   146         0.517  
100 Adelie    female           40.2   146         0.517  
101 Adelie    female           40.3   146         0.554  
102 Adelie    male             40.3   146         0.554  
103 Adelie    female           40.5   146         0.629  
104 Adelie    male             40.5   146         0.629  
105 Adelie    male             40.6   146         0.667  
106 Adelie    male             40.6   146         0.667  
107 Adelie    male             40.6   146         0.667  
108 Adelie    male             40.6   146         0.667  
109 Adelie    male             40.7   146         0.705  
110 Adelie    male             40.8   146         0.742  
111 Adelie    male             40.8   146         0.742  
112 Adelie    male             40.9   146         0.780  
113 Adelie    female           40.9   146         0.780  
114 Adelie    male             41     146         0.817  
115 Adelie    female           41.1   146         0.855  
116 Adelie    male             41.1   146         0.855  
117 Adelie    male             41.1   146         0.855  
118 Adelie    male             41.1   146         0.855  
119 Adelie    male             41.1   146         0.855  
120 Adelie    male             41.1   146         0.855  
121 Adelie    male             41.1   146         0.855  
122 Adelie    male             41.3   146         0.930  
123 Adelie    male             41.3   146         0.930  
124 Adelie    male             41.4   146         0.967  
125 Adelie    male             41.4   146         0.967  
126 Adelie    male             41.5   146         1.01   
127 Adelie    male             41.5   146         1.01   
128 Adelie    male             41.6   146         1.04   
129 Adelie    male             41.8   146         1.12   
130 Adelie    male             42     146         1.19   
131 Adelie    male             42.1   146         1.23   
132 Adelie    female           42.2   146         1.27   
133 Adelie    male             42.2   146         1.27   
134 Adelie    male             42.3   146         1.31   
135 Adelie    male             42.5   146         1.38   
136 Adelie    male             42.7   146         1.46   
137 Adelie    male             42.8   146         1.49   
138 Adelie    male             42.9   146         1.53   
139 Adelie    male             43.1   146         1.61   
140 Adelie    male             43.2   146         1.64   
141 Adelie    male             43.2   146         1.64   
142 Adelie    male             44.1   146         1.98   
143 Adelie    male             44.1   146         1.98   
144 Adelie    male             45.6   146         2.54   
145 Adelie    male             45.8   146         2.62   
146 Adelie    male             46     146         2.70   
147 Chinstrap female           40.9    68        -2.38   
148 Chinstrap female           42.4    68        -1.93   
149 Chinstrap female           42.5    68        -1.90   
150 Chinstrap female           42.5    68        -1.90   
151 Chinstrap female           43.2    68        -1.69   
152 Chinstrap female           43.5    68        -1.60   
153 Chinstrap female           45.2    68        -1.09   
154 Chinstrap female           45.2    68        -1.09   
155 Chinstrap female           45.4    68        -1.03   
156 Chinstrap female           45.5    68        -0.998  
157 Chinstrap female           45.6    68        -0.968  
158 Chinstrap female           45.7    68        -0.938  
159 Chinstrap female           45.7    68        -0.938  
160 Chinstrap female           45.9    68        -0.879  
161 Chinstrap female           46      68        -0.849  
162 Chinstrap female           46.1    68        -0.819  
163 Chinstrap female           46.2    68        -0.789  
164 Chinstrap female           46.4    68        -0.729  
165 Chinstrap female           46.4    68        -0.729  
166 Chinstrap female           46.5    68        -0.699  
167 Chinstrap female           46.6    68        -0.669  
168 Chinstrap female           46.7    68        -0.639  
169 Chinstrap female           46.8    68        -0.609  
170 Chinstrap female           46.9    68        -0.579  
171 Chinstrap female           47      68        -0.549  
172 Chinstrap female           47.5    68        -0.399  
173 Chinstrap female           47.6    68        -0.369  
174 Chinstrap female           48.1    68        -0.220  
175 Chinstrap male             48.5    68        -0.100  
176 Chinstrap male             49      68         0.0498 
177 Chinstrap male             49      68         0.0498 
178 Chinstrap male             49.2    68         0.110  
179 Chinstrap male             49.3    68         0.140  
180 Chinstrap male             49.5    68         0.199  
181 Chinstrap male             49.6    68         0.229  
182 Chinstrap male             49.7    68         0.259  
183 Chinstrap female           49.8    68         0.289  
184 Chinstrap male             50      68         0.349  
185 Chinstrap female           50.1    68         0.379  
186 Chinstrap male             50.2    68         0.409  
187 Chinstrap female           50.2    68         0.409  
188 Chinstrap male             50.3    68         0.439  
189 Chinstrap male             50.5    68         0.499  
190 Chinstrap female           50.5    68         0.499  
191 Chinstrap male             50.6    68         0.529  
192 Chinstrap male             50.7    68         0.559  
193 Chinstrap male             50.8    68         0.589  
194 Chinstrap male             50.8    68         0.589  
195 Chinstrap male             50.9    68         0.619  
196 Chinstrap female           50.9    68         0.619  
197 Chinstrap male             51      68         0.649  
198 Chinstrap male             51.3    68         0.739  
199 Chinstrap male             51.3    68         0.739  
200 Chinstrap male             51.3    68         0.739  
201 Chinstrap male             51.4    68         0.768  
202 Chinstrap male             51.5    68         0.798  
203 Chinstrap male             51.7    68         0.858  
204 Chinstrap male             51.9    68         0.918  
205 Chinstrap male             52      68         0.948  
206 Chinstrap male             52      68         0.948  
207 Chinstrap male             52      68         0.948  
208 Chinstrap male             52.2    68         1.01   
209 Chinstrap male             52.7    68         1.16   
210 Chinstrap male             52.8    68         1.19   
211 Chinstrap male             53.5    68         1.40   
212 Chinstrap male             54.2    68         1.61   
213 Chinstrap male             55.8    68         2.09   
214 Chinstrap female           58      68         2.74   
215 Gentoo    female           40.9   119        -2.15   
216 Gentoo    female           41.7   119        -1.89   
217 Gentoo    female           42     119        -1.79   
218 Gentoo    female           42.6   119        -1.60   
219 Gentoo    female           42.7   119        -1.57   
220 Gentoo    female           42.8   119        -1.54   
221 Gentoo    female           42.9   119        -1.50   
222 Gentoo    female           43.2   119        -1.41   
223 Gentoo    female           43.3   119        -1.37   
224 Gentoo    female           43.3   119        -1.37   
225 Gentoo    female           43.4   119        -1.34   
226 Gentoo    female           43.5   119        -1.31   
227 Gentoo    female           43.5   119        -1.31   
228 Gentoo    female           43.6   119        -1.28   
229 Gentoo    female           43.8   119        -1.21   
230 Gentoo    female           44     119        -1.15   
231 Gentoo    male             44.4   119        -1.02   
232 Gentoo    female           44.5   119        -0.988  
233 Gentoo    female           44.9   119        -0.859  
234 Gentoo    female           44.9   119        -0.859  
235 Gentoo    male             45     119        -0.827  
236 Gentoo    female           45.1   119        -0.795  
237 Gentoo    female           45.1   119        -0.795  
238 Gentoo    female           45.1   119        -0.795  
239 Gentoo    male             45.2   119        -0.762  
240 Gentoo    female           45.2   119        -0.762  
241 Gentoo    male             45.2   119        -0.762  
242 Gentoo    female           45.2   119        -0.762  
243 Gentoo    female           45.3   119        -0.730  
244 Gentoo    female           45.3   119        -0.730  
245 Gentoo    female           45.4   119        -0.698  
246 Gentoo    female           45.5   119        -0.666  
247 Gentoo    female           45.5   119        -0.666  
248 Gentoo    male             45.5   119        -0.666  
249 Gentoo    female           45.5   119        -0.666  
250 Gentoo    female           45.7   119        -0.601  
251 Gentoo    female           45.8   119        -0.569  
252 Gentoo    female           45.8   119        -0.569  
253 Gentoo    female           46.1   119        -0.473  
254 Gentoo    male             46.1   119        -0.473  
255 Gentoo    female           46.2   119        -0.440  
256 Gentoo    male             46.2   119        -0.440  
257 Gentoo    female           46.2   119        -0.440  
258 Gentoo    male             46.3   119        -0.408  
259 Gentoo    male             46.4   119        -0.376  
260 Gentoo    female           46.4   119        -0.376  
261 Gentoo    female           46.5   119        -0.344  
262 Gentoo    female           46.5   119        -0.344  
263 Gentoo    female           46.5   119        -0.344  
264 Gentoo    female           46.5   119        -0.344  
265 Gentoo    female           46.6   119        -0.312  
266 Gentoo    male             46.7   119        -0.279  
267 Gentoo    male             46.8   119        -0.247  
268 Gentoo    male             46.8   119        -0.247  
269 Gentoo    female           46.8   119        -0.247  
270 Gentoo    female           46.9   119        -0.215  
271 Gentoo    female           47.2   119        -0.118  
272 Gentoo    female           47.2   119        -0.118  
273 Gentoo    male             47.3   119        -0.0863 
274 Gentoo    female           47.4   119        -0.0541 
275 Gentoo    female           47.5   119        -0.0219 
276 Gentoo    female           47.5   119        -0.0219 
277 Gentoo    female           47.5   119        -0.0219 
278 Gentoo    male             47.6   119         0.0103 
279 Gentoo    female           47.7   119         0.0425 
280 Gentoo    male             47.8   119         0.0747 
281 Gentoo    male             48.1   119         0.171  
282 Gentoo    female           48.2   119         0.203  
283 Gentoo    male             48.2   119         0.203  
284 Gentoo    male             48.4   119         0.268  
285 Gentoo    male             48.4   119         0.268  
286 Gentoo    female           48.4   119         0.268  
287 Gentoo    male             48.5   119         0.300  
288 Gentoo    female           48.5   119         0.300  
289 Gentoo    male             48.6   119         0.332  
290 Gentoo    female           48.7   119         0.364  
291 Gentoo    male             48.7   119         0.364  
292 Gentoo    male             48.7   119         0.364  
293 Gentoo    male             48.8   119         0.397  
294 Gentoo    male             49     119         0.461  
295 Gentoo    female           49.1   119         0.493  
296 Gentoo    female           49.1   119         0.493  
297 Gentoo    male             49.1   119         0.493  
298 Gentoo    male             49.2   119         0.525  
299 Gentoo    male             49.3   119         0.558  
300 Gentoo    male             49.4   119         0.590  
301 Gentoo    male             49.5   119         0.622  
302 Gentoo    male             49.5   119         0.622  
303 Gentoo    male             49.6   119         0.654  
304 Gentoo    male             49.6   119         0.654  
305 Gentoo    male             49.8   119         0.719  
306 Gentoo    male             49.8   119         0.719  
307 Gentoo    male             49.9   119         0.751  
308 Gentoo    male             50     119         0.783  
309 Gentoo    male             50     119         0.783  
310 Gentoo    male             50     119         0.783  
311 Gentoo    male             50     119         0.783  
312 Gentoo    male             50.1   119         0.815  
313 Gentoo    male             50.2   119         0.847  
314 Gentoo    male             50.4   119         0.912  
315 Gentoo    male             50.4   119         0.912  
316 Gentoo    male             50.5   119         0.944  
317 Gentoo    male             50.5   119         0.944  
318 Gentoo    female           50.5   119         0.944  
319 Gentoo    male             50.7   119         1.01   
320 Gentoo    male             50.8   119         1.04   
321 Gentoo    male             50.8   119         1.04   
322 Gentoo    male             51.1   119         1.14   
323 Gentoo    male             51.1   119         1.14   
324 Gentoo    male             51.3   119         1.20   
325 Gentoo    male             51.5   119         1.27   
326 Gentoo    male             52.1   119         1.46   
327 Gentoo    male             52.2   119         1.49   
328 Gentoo    male             52.5   119         1.59   
329 Gentoo    male             53.4   119         1.88   
330 Gentoo    male             54.3   119         2.17   
331 Gentoo    male             55.1   119         2.42   
332 Gentoo    male             55.9   119         2.68   
333 Gentoo    male             59.6   119         3.87   
```
:::


``` r
# get the largest 3 penguins by bill depth from each species
penguins %>%
  group_by(species) %>%
  slice_max(bill_depth_mm, n = 3)
```

```
# A tibble: 9 × 8
# Groups:   species [3]
  species   island   bill_length_mm bill_depth_mm flipper_length_mm body_mass_g sex  
  <chr>     <chr>             <dbl>         <dbl>             <dbl>       <dbl> <chr>
1 Adelie    Torgers…           46            21.5               194        4200 male 
2 Adelie    Torgers…           38.6          21.2               191        3800 male 
3 Adelie    Dream              42.3          21.2               191        4150 male 
4 Chinstrap Dream              54.2          20.8               201        4300 male 
5 Chinstrap Dream              52            20.7               210        4800 male 
6 Chinstrap Dream              51.7          20.3               194        3775 male 
7 Gentoo    Biscoe             44.4          17.3               219        5250 male 
8 Gentoo    Biscoe             50.8          17.3               228        5600 male 
9 Gentoo    Biscoe             52.2          17.1               228        5400 male 
# ℹ 1 more variable: year <dbl>
```


### Regrouping

Sometimes one `group_by()` may not be enough to get what you need; you may need to re-`group_by()` by something else to finish the job. For example, suppose you want to see what percent of each species came from different islands. This requires two uses of `group_by()`:


``` r
# first group by species + island and summarize to get size of each group,
# then regroup by species and MUTATE (not summarize) totals for each species,
# then divide these to get proportion of each species from each island
penguins %>%
  group_by(species, island) %>%
  summarize(n = n()) %>%
  group_by(species) %>%
  mutate(
    species_total = sum(n),
    pct_of_species_from_island = n / species_total * 100
  )
```

```
# A tibble: 5 × 5
# Groups:   species [3]
  species   island        n species_total pct_of_species_from_island
  <chr>     <chr>     <int>         <int>                      <dbl>
1 Adelie    Biscoe       44           146                       30.1
2 Adelie    Dream        55           146                       37.7
3 Adelie    Torgersen    47           146                       32.2
4 Chinstrap Dream        68            68                      100  
5 Gentoo    Biscoe      119           119                      100  
```

This combination of `df %>% group_by(...) %>% summarize(n = n())` is so common, we have this shortcut for it: `df %>% count(...)`. We can demonstrate this in another example involving regrouping. Suppose we want to know what percent of each species were male/female:


``` r
# again, first group by species + sex and get size using the shortcut count(),
# then regroup by species and MUTATE totals for each species,
# then divide to get proportions of each species that were male/female
penguins %>%
  count(species, sex) %>%
  group_by(species) %>%
  mutate(
    species_total = sum(n),
    pct_of_species_each_sex = n / species_total * 100
  )
```

```
# A tibble: 6 × 5
# Groups:   species [3]
  species   sex        n species_total pct_of_species_each_sex
  <chr>     <chr>  <int>         <int>                   <dbl>
1 Adelie    female    73           146                    50  
2 Adelie    male      73           146                    50  
3 Chinstrap female    34            68                    50  
4 Chinstrap male      34            68                    50  
5 Gentoo    female    58           119                    48.7
6 Gentoo    male      61           119                    51.3
```

Groups are also useful for prepping data frames for plotting. For example, here's a chunk that produces a bar plot showing how mean body mass changes by species and sex:


``` r
# get mean body mass by species + sex and plot
# the %T>% is a special pipe called a Tee pipe
# it's a shortcut for piping something into 2 different operations,
# useful for example when you want to print a data frame, then also plot it
# see https://magrittr.tidyverse.org/reference/tee.html for more
penguins %>% 
  group_by(species, sex) %>% 
  summarize(mean_mass = mean(body_mass_g)) %T>% print %>% 
  ggplot(aes(x = species, y = mean_mass, fill = sex)) +
  geom_col(position = "dodge2") +
  labs(x = "Species", y = "Mean body mass (g)",
       title = "Mean body mass of Palmer penguins by species + sex")
```

```
# A tibble: 6 × 3
# Groups:   species [3]
  species   sex    mean_mass
  <chr>     <chr>      <dbl>
1 Adelie    female     3369.
2 Adelie    male       4043.
3 Chinstrap female     3527.
4 Chinstrap male       3939.
5 Gentoo    female     4680.
6 Gentoo    male       5485.
```

<img src="08-advanced-operations_files/figure-html/unnamed-chunk-8-1.svg" width="672" style="display: block; margin: auto;" />


### Ungrouping

Many operations output grouped data frames. For example, look closely at the output of the previous chunks and you'll see `# Groups:   species [3]` in most of them. This means any further operations you run will continue to execute in a grouped way.

You can remove the grouping structure with `ungroup()`. This allows you to revert to running operations on the entire data frame. Example:


``` r
# get count of each species + sex combination,
# but this time get its percentage out of ALL observations
penguins %>%
  count(species, sex) %>%
  ungroup() %>%
  mutate(pct_of_all = n / sum(n))
```

```
# A tibble: 6 × 4
  species   sex        n pct_of_all
  <chr>     <chr>  <int>      <dbl>
1 Adelie    female    73      0.219
2 Adelie    male      73      0.219
3 Chinstrap female    34      0.102
4 Chinstrap male      34      0.102
5 Gentoo    female    58      0.174
6 Gentoo    male      61      0.183
```


### More practice!

Let's give the penguins dataset a rest and practice dplyr and grouping a bit more with a different dataset. The following chunk imports [`fertility.csv`](data/fertility.csv), the cleaned global fertility data set from [World Bank](https://data.worldbank.org/indicator/SP.DYN.TFRT.IN), giving the average number of births per woman for each year and country from 1960 to present. For the past few decades, global fertility has been [sharply declining](https://ourworldindata.org/un-population-2024-revision) for most countries. Many countries are now below the [replacement rate of 2.1](https://en.wikipedia.org/wiki/Sub-replacement_fertility), leading to widespread concerns of a population collapse in the latter part of the 21^st^ century.


``` r
fertility <- read_csv(
  "https://bwu62.github.io/stat240-revamp/data/fertility.csv",
  show_col_types = FALSE
)
fertility
```

```
# A tibble: 13,050 × 5
   country     region     income_group  year  rate
   <chr>       <chr>      <chr>        <dbl> <dbl>
 1 Afghanistan South Asia Low           1960  7.28
 2 Afghanistan South Asia Low           1961  7.28
 3 Afghanistan South Asia Low           1962  7.29
 4 Afghanistan South Asia Low           1963  7.30
 5 Afghanistan South Asia Low           1964  7.30
 6 Afghanistan South Asia Low           1965  7.30
 7 Afghanistan South Asia Low           1966  7.32
 8 Afghanistan South Asia Low           1967  7.34
 9 Afghanistan South Asia Low           1968  7.36
10 Afghanistan South Asia Low           1969  7.39
# ℹ 13,040 more rows
```

Each country has over 60 years of data in this dataset. We can see an overview which countries are represented in the dataset and what their listed region and income group are by temporarily dropping years, removing duplicates, and printing the full output below in a collapsible box:

:::{.fold .o}

``` r
fertility %>%
  select(country:income_group) %>%
  distinct() %>%
  print(n = Inf)
```

```
# A tibble: 212 × 3
    country                        region                     income_group
    <chr>                          <chr>                      <chr>       
  1 Afghanistan                    South Asia                 Low         
  2 Albania                        Europe & Central Asia      Upper middle
  3 Algeria                        Middle East & North Africa Upper middle
  4 Andorra                        Europe & Central Asia      High        
  5 Angola                         Sub-Saharan Africa         Lower middle
  6 Antigua and Barbuda            Latin America & Caribbean  High        
  7 Argentina                      Latin America & Caribbean  Upper middle
  8 Armenia                        Europe & Central Asia      Upper middle
  9 Aruba                          Latin America & Caribbean  High        
 10 Australia                      East Asia & Pacific        High        
 11 Austria                        Europe & Central Asia      High        
 12 Azerbaijan                     Europe & Central Asia      Upper middle
 13 Bahamas, The                   Latin America & Caribbean  High        
 14 Bahrain                        Middle East & North Africa High        
 15 Bangladesh                     South Asia                 Lower middle
 16 Barbados                       Latin America & Caribbean  High        
 17 Belarus                        Europe & Central Asia      Upper middle
 18 Belgium                        Europe & Central Asia      High        
 19 Belize                         Latin America & Caribbean  Upper middle
 20 Benin                          Sub-Saharan Africa         Lower middle
 21 Bermuda                        North America              High        
 22 Bhutan                         South Asia                 Lower middle
 23 Bolivia                        Latin America & Caribbean  Lower middle
 24 Bosnia and Herzegovina         Europe & Central Asia      Upper middle
 25 Botswana                       Sub-Saharan Africa         Upper middle
 26 Brazil                         Latin America & Caribbean  Upper middle
 27 British Virgin Islands         Latin America & Caribbean  High        
 28 Brunei Darussalam              East Asia & Pacific        High        
 29 Bulgaria                       Europe & Central Asia      High        
 30 Burkina Faso                   Sub-Saharan Africa         Low         
 31 Burundi                        Sub-Saharan Africa         Low         
 32 Cabo Verde                     Sub-Saharan Africa         Lower middle
 33 Cambodia                       East Asia & Pacific        Lower middle
 34 Cameroon                       Sub-Saharan Africa         Lower middle
 35 Canada                         North America              High        
 36 Central African Republic       Sub-Saharan Africa         Low         
 37 Chad                           Sub-Saharan Africa         Low         
 38 Channel Islands                Europe & Central Asia      High        
 39 Chile                          Latin America & Caribbean  High        
 40 China                          East Asia & Pacific        Upper middle
 41 Colombia                       Latin America & Caribbean  Upper middle
 42 Comoros                        Sub-Saharan Africa         Lower middle
 43 Congo, Dem. Rep.               Sub-Saharan Africa         Low         
 44 Congo, Rep.                    Sub-Saharan Africa         Lower middle
 45 Costa Rica                     Latin America & Caribbean  Upper middle
 46 Croatia                        Europe & Central Asia      High        
 47 Cuba                           Latin America & Caribbean  Upper middle
 48 Curaçao                        Latin America & Caribbean  High        
 49 Cyprus                         Europe & Central Asia      High        
 50 Czechia                        Europe & Central Asia      High        
 51 Côte d'Ivoire                  Sub-Saharan Africa         Lower middle
 52 Denmark                        Europe & Central Asia      High        
 53 Djibouti                       Middle East & North Africa Lower middle
 54 Dominica                       Latin America & Caribbean  Upper middle
 55 Dominican Republic             Latin America & Caribbean  Upper middle
 56 Ecuador                        Latin America & Caribbean  Upper middle
 57 Egypt, Arab Rep.               Middle East & North Africa Lower middle
 58 El Salvador                    Latin America & Caribbean  Upper middle
 59 Equatorial Guinea              Sub-Saharan Africa         Upper middle
 60 Eritrea                        Sub-Saharan Africa         Low         
 61 Estonia                        Europe & Central Asia      High        
 62 Eswatini                       Sub-Saharan Africa         Lower middle
 63 Ethiopia                       Sub-Saharan Africa         Low         
 64 Faroe Islands                  Europe & Central Asia      High        
 65 Fiji                           East Asia & Pacific        Upper middle
 66 Finland                        Europe & Central Asia      High        
 67 France                         Europe & Central Asia      High        
 68 French Polynesia               East Asia & Pacific        High        
 69 Gabon                          Sub-Saharan Africa         Upper middle
 70 Gambia, The                    Sub-Saharan Africa         Low         
 71 Georgia                        Europe & Central Asia      Upper middle
 72 Germany                        Europe & Central Asia      High        
 73 Ghana                          Sub-Saharan Africa         Lower middle
 74 Gibraltar                      Europe & Central Asia      High        
 75 Greece                         Europe & Central Asia      High        
 76 Greenland                      Europe & Central Asia      High        
 77 Grenada                        Latin America & Caribbean  Upper middle
 78 Guam                           East Asia & Pacific        High        
 79 Guatemala                      Latin America & Caribbean  Upper middle
 80 Guinea                         Sub-Saharan Africa         Lower middle
 81 Guinea-Bissau                  Sub-Saharan Africa         Low         
 82 Guyana                         Latin America & Caribbean  High        
 83 Haiti                          Latin America & Caribbean  Lower middle
 84 Honduras                       Latin America & Caribbean  Lower middle
 85 Hong Kong                      East Asia & Pacific        High        
 86 Hungary                        Europe & Central Asia      High        
 87 Iceland                        Europe & Central Asia      High        
 88 India                          South Asia                 Lower middle
 89 Indonesia                      East Asia & Pacific        Upper middle
 90 Iran, Islamic Rep.             Middle East & North Africa Upper middle
 91 Iraq                           Middle East & North Africa Upper middle
 92 Ireland                        Europe & Central Asia      High        
 93 Isle of Man                    Europe & Central Asia      High        
 94 Israel                         Middle East & North Africa High        
 95 Italy                          Europe & Central Asia      High        
 96 Jamaica                        Latin America & Caribbean  Upper middle
 97 Japan                          East Asia & Pacific        High        
 98 Jordan                         Middle East & North Africa Lower middle
 99 Kazakhstan                     Europe & Central Asia      Upper middle
100 Kenya                          Sub-Saharan Africa         Lower middle
101 Kiribati                       East Asia & Pacific        Lower middle
102 Korea, Dem. People's Rep.      East Asia & Pacific        Low         
103 Korea, Rep.                    East Asia & Pacific        High        
104 Kosovo                         Europe & Central Asia      Upper middle
105 Kuwait                         Middle East & North Africa High        
106 Kyrgyz Republic                Europe & Central Asia      Lower middle
107 Lao PDR                        East Asia & Pacific        Lower middle
108 Latvia                         Europe & Central Asia      High        
109 Lebanon                        Middle East & North Africa Lower middle
110 Lesotho                        Sub-Saharan Africa         Lower middle
111 Liberia                        Sub-Saharan Africa         Low         
112 Libya                          Middle East & North Africa Upper middle
113 Liechtenstein                  Europe & Central Asia      High        
114 Lithuania                      Europe & Central Asia      High        
115 Luxembourg                     Europe & Central Asia      High        
116 Macao                          East Asia & Pacific        High        
117 Madagascar                     Sub-Saharan Africa         Low         
118 Malawi                         Sub-Saharan Africa         Low         
119 Malaysia                       East Asia & Pacific        Upper middle
120 Maldives                       South Asia                 Upper middle
121 Mali                           Sub-Saharan Africa         Low         
122 Malta                          Middle East & North Africa High        
123 Marshall Islands               East Asia & Pacific        Upper middle
124 Mauritania                     Sub-Saharan Africa         Lower middle
125 Mauritius                      Sub-Saharan Africa         Upper middle
126 Mexico                         Latin America & Caribbean  Upper middle
127 Micronesia, Fed. Sts.          East Asia & Pacific        Lower middle
128 Moldova                        Europe & Central Asia      Upper middle
129 Mongolia                       East Asia & Pacific        Upper middle
130 Montenegro                     Europe & Central Asia      Upper middle
131 Morocco                        Middle East & North Africa Lower middle
132 Mozambique                     Sub-Saharan Africa         Low         
133 Myanmar                        East Asia & Pacific        Lower middle
134 Namibia                        Sub-Saharan Africa         Upper middle
135 Nauru                          East Asia & Pacific        High        
136 Nepal                          South Asia                 Lower middle
137 Netherlands                    Europe & Central Asia      High        
138 New Caledonia                  East Asia & Pacific        High        
139 New Zealand                    East Asia & Pacific        High        
140 Nicaragua                      Latin America & Caribbean  Lower middle
141 Niger                          Sub-Saharan Africa         Low         
142 Nigeria                        Sub-Saharan Africa         Lower middle
143 North Macedonia                Europe & Central Asia      Upper middle
144 Norway                         Europe & Central Asia      High        
145 Oman                           Middle East & North Africa High        
146 Pakistan                       South Asia                 Lower middle
147 Palau                          East Asia & Pacific        High        
148 Panama                         Latin America & Caribbean  High        
149 Papua New Guinea               East Asia & Pacific        Lower middle
150 Paraguay                       Latin America & Caribbean  Upper middle
151 Peru                           Latin America & Caribbean  Upper middle
152 Philippines                    East Asia & Pacific        Lower middle
153 Poland                         Europe & Central Asia      High        
154 Portugal                       Europe & Central Asia      High        
155 Puerto Rico                    Latin America & Caribbean  High        
156 Qatar                          Middle East & North Africa High        
157 Romania                        Europe & Central Asia      High        
158 Russian Federation             Europe & Central Asia      High        
159 Rwanda                         Sub-Saharan Africa         Low         
160 Samoa                          East Asia & Pacific        Lower middle
161 San Marino                     Europe & Central Asia      High        
162 Saudi Arabia                   Middle East & North Africa High        
163 Senegal                        Sub-Saharan Africa         Lower middle
164 Serbia                         Europe & Central Asia      Upper middle
165 Seychelles                     Sub-Saharan Africa         High        
166 Sierra Leone                   Sub-Saharan Africa         Low         
167 Singapore                      East Asia & Pacific        High        
168 Sint Maarten (Dutch part)      Latin America & Caribbean  High        
169 Slovak Republic                Europe & Central Asia      High        
170 Slovenia                       Europe & Central Asia      High        
171 Solomon Islands                East Asia & Pacific        Lower middle
172 Somalia                        Sub-Saharan Africa         Low         
173 South Africa                   Sub-Saharan Africa         Upper middle
174 South Sudan                    Sub-Saharan Africa         Low         
175 Spain                          Europe & Central Asia      High        
176 Sri Lanka                      South Asia                 Lower middle
177 St. Kitts and Nevis            Latin America & Caribbean  High        
178 St. Lucia                      Latin America & Caribbean  Upper middle
179 St. Martin (French part)       Latin America & Caribbean  High        
180 St. Vincent and the Grenadines Latin America & Caribbean  Upper middle
181 Sudan                          Sub-Saharan Africa         Low         
182 Suriname                       Latin America & Caribbean  Upper middle
183 Sweden                         Europe & Central Asia      High        
184 Switzerland                    Europe & Central Asia      High        
185 Syrian Arab Republic           Middle East & North Africa Low         
186 São Tomé and Principe          Sub-Saharan Africa         Lower middle
187 Tajikistan                     Europe & Central Asia      Lower middle
188 Tanzania                       Sub-Saharan Africa         Lower middle
189 Thailand                       East Asia & Pacific        Upper middle
190 Timor-Leste                    East Asia & Pacific        Lower middle
191 Togo                           Sub-Saharan Africa         Low         
192 Tonga                          East Asia & Pacific        Upper middle
193 Trinidad and Tobago            Latin America & Caribbean  High        
194 Tunisia                        Middle East & North Africa Lower middle
195 Turkmenistan                   Europe & Central Asia      Upper middle
196 Turks and Caicos Islands       Latin America & Caribbean  High        
197 Tuvalu                         East Asia & Pacific        Upper middle
198 Türkiye                        Europe & Central Asia      Upper middle
199 Uganda                         Sub-Saharan Africa         Low         
200 Ukraine                        Europe & Central Asia      Upper middle
201 United Arab Emirates           Middle East & North Africa High        
202 United Kingdom                 Europe & Central Asia      High        
203 United States                  North America              High        
204 Uruguay                        Latin America & Caribbean  High        
205 Uzbekistan                     Europe & Central Asia      Lower middle
206 Vanuatu                        East Asia & Pacific        Lower middle
207 Viet Nam                       East Asia & Pacific        Lower middle
208 Virgin Islands (U.S.)          Latin America & Caribbean  High        
209 West Bank and Gaza             Middle East & North Africa Lower middle
210 Yemen, Rep.                    Middle East & North Africa Low         
211 Zambia                         Sub-Saharan Africa         Lower middle
212 Zimbabwe                       Sub-Saharan Africa         Lower middle
```
:::

One additional small processing step we should do before continuing is convert `income.group` to an ordered factor (see section \@ref(ordered-data)), which will be important later.


``` r
fertility <- fertility %>% mutate(
  income_group = factor(income_group, ordered = TRUE, levels = c(
    "Low", "Lower middle", "Upper middle", "High"))
)
```


We can begin by running a few summaries to explore the dataset. To start, here's a chunk showing the number of countries and median income group for countries in each region:


``` r
# strangely, base R median doesn't work on ordered categories,
# but we can use Median from DescTools instead
fertility %>%
  select(country, region, income_group) %>%
  distinct() %>%
  group_by(region) %>%
  summarize(n = n(), median = DescTools::Median(income_group)) %>%
  arrange(desc(median))
```

```
# A tibble: 7 × 3
  region                         n median      
  <chr>                      <int> <ord>       
1 Europe & Central Asia         57 High        
2 North America                  3 High        
3 East Asia & Pacific           35 Upper middle
4 Latin America & Caribbean     40 Upper middle
5 Middle East & North Africa    21 Upper middle
6 South Asia                     8 Lower middle
7 Sub-Saharan Africa            48 Lower middle
```

Next, here's a chunk showing the median fertility rate in each region for the most recent year of 2022, as well as the countries with the highest and lowest 2022 rates (and what the rates are) in each region:


``` r
# first filter to get the right year, then
# sort by region, rate (so min, max are the first, last in each group)
# then summarize to get median, and min/max country/rate
fertility %>%
  filter(year == max(year)) %>%
  arrange(region, rate) %>%
  group_by(region) %>%
  summarize(
    n           = n(),
    median      = median(rate),
    min_country = first(country),
    min         = first(rate),
    max_country = last(country),
    max         = last(rate)
  ) %>%
  arrange(median)
```

```
# A tibble: 7 × 7
  region                         n median min_country   min max_country       max
  <chr>                      <int>  <dbl> <chr>       <dbl> <chr>           <dbl>
1 North America                  3   1.33 Bermuda     1.3   United States    1.66
2 Europe & Central Asia         55   1.53 Spain       1.16  Uzbekistan       3.31
3 Latin America & Caribbean     40   1.74 Puerto Rico 0.9   Haiti            2.77
4 South Asia                     8   1.99 Bhutan      1.40  Afghanistan      4.52
5 East Asia & Pacific           34   2.24 Hong Kong   0.701 Solomon Islands  3.92
6 Middle East & North Africa    21   2.40 Malta       1.15  Yemen, Rep.      3.72
7 Sub-Saharan Africa            48   4.18 Mauritius   1.32  Niger            6.75
```

We can also show the latest rate for each country, as well as the change from 2000, just before the start of the 21^st^ century:

:::{.fold .o}

``` r
# first filter to get the right years, then
# sort by country, year (so 2000, 2022 are first and last in each group)
# then summarize to get 2000 and 2022 rates, mutate to get change,
# then ungroup, distinct, and arrange to display a neat output
# again, collapsing output due to lengthy print out
fertility %>%
  filter(year %in% c(2000, max(year))) %>%
  arrange(country, year) %>%
  group_by(country) %>%
  mutate(
    rate2000 = first(rate),
    rate2022 = last(rate),
    change = rate2022 - rate2000
  ) %>% 
  select(country, region, rate2000, change, rate2022) %>% 
  ungroup() %>% 
  distinct() %>% 
  arrange(rate2022) %>% 
  print(n = Inf)
```

```
# A tibble: 210 × 5
    country                        region                  rate2000   change rate2022
    <chr>                          <chr>                      <dbl>    <dbl>    <dbl>
  1 Hong Kong                      East Asia & Pacific        1.03  -0.331      0.701
  2 Korea, Rep.                    East Asia & Pacific        1.48  -0.702      0.778
  3 Puerto Rico                    Latin America & Caribb…    2.05  -1.15       0.9  
  4 British Virgin Islands         Latin America & Caribb…    1.87  -0.851      1.01 
  5 Singapore                      East Asia & Pacific        1.6   -0.56       1.04 
  6 Macao                          East Asia & Pacific        0.912  0.197      1.11 
  7 Malta                          Middle East & North Af…    1.68  -0.53       1.15 
  8 Spain                          Europe & Central Asia      1.22  -0.0600     1.16 
  9 China                          East Asia & Pacific        1.63  -0.453      1.18 
 10 Aruba                          Latin America & Caribb…    1.90  -0.725      1.18 
 11 Italy                          Europe & Central Asia      1.26  -0.0200     1.24 
 12 Japan                          East Asia & Pacific        1.36  -0.100      1.26 
 13 Poland                         Europe & Central Asia      1.37  -0.109      1.26 
 14 Ukraine                        Europe & Central Asia      1.12   0.149      1.26 
 15 Lithuania                      Europe & Central Asia      1.39  -0.120      1.27 
 16 Bermuda                        North America              1.74  -0.44       1.3  
 17 Curaçao                        Latin America & Caribb…    2.19  -0.89       1.3  
 18 Luxembourg                     Europe & Central Asia      1.76  -0.45       1.31 
 19 Cyprus                         Europe & Central Asia      1.64  -0.326      1.31 
 20 Thailand                       East Asia & Pacific        1.61  -0.295      1.32 
 21 Finland                        Europe & Central Asia      1.73  -0.41       1.32 
 22 Mauritius                      Sub-Saharan Africa         1.99  -0.67       1.32 
 23 Canada                         North America              1.51  -0.18       1.33 
 24 Jamaica                        Latin America & Caribb…    2.21  -0.87       1.34 
 25 Bosnia and Herzegovina         Europe & Central Asia      1.28   0.0630     1.35 
 26 Albania                        Europe & Central Asia      2.23  -0.855      1.38 
 27 Bahamas, The                   Latin America & Caribb…    2.10  -0.717      1.38 
 28 St. Lucia                      Latin America & Caribb…    2.20  -0.815      1.39 
 29 Switzerland                    Europe & Central Asia      1.5   -0.110      1.39 
 30 Bhutan                         South Asia                 3.41  -2.02       1.40 
 31 Austria                        Europe & Central Asia      1.36   0.0500     1.41 
 32 Estonia                        Europe & Central Asia      1.36   0.0500     1.41 
 33 Norway                         Europe & Central Asia      1.85  -0.44       1.41 
 34 Russian Federation             Europe & Central Asia      1.20   0.221      1.42 
 35 Greece                         Europe & Central Asia      1.25   0.18       1.43 
 36 Portugal                       Europe & Central Asia      1.55  -0.120      1.43 
 37 United Arab Emirates           Middle East & North Af…    2.73  -1.29       1.44 
 38 Cuba                           Latin America & Caribb…    1.58  -0.132      1.45 
 39 Germany                        Europe & Central Asia      1.38   0.0750     1.46 
 40 Channel Islands                Europe & Central Asia      1.49  -0.0180     1.47 
 41 Latvia                         Europe & Central Asia      1.25   0.22       1.47 
 42 Liechtenstein                  Europe & Central Asia      1.57  -0.100      1.47 
 43 Uruguay                        Latin America & Caribb…    2.17  -0.685      1.48 
 44 Netherlands                    Europe & Central Asia      1.72  -0.233      1.49 
 45 Belarus                        Europe & Central Asia      1.32   0.178      1.50 
 46 Kosovo                         Europe & Central Asia      2.66  -1.15       1.51 
 47 St. Kitts and Nevis            Latin America & Caribb…    2.20  -0.684      1.51 
 48 Hungary                        Europe & Central Asia      1.32   0.2        1.52 
 49 Sweden                         Europe & Central Asia      1.54  -0.0200     1.52 
 50 Costa Rica                     Latin America & Caribb…    2.41  -0.89       1.52 
 51 Belgium                        Europe & Central Asia      1.67  -0.140      1.53 
 52 Croatia                        Europe & Central Asia      1.39   0.140      1.53 
 53 Chile                          Latin America & Caribb…    1.99  -0.448      1.54 
 54 Denmark                        Europe & Central Asia      1.77  -0.22       1.55 
 55 Slovenia                       Europe & Central Asia      1.26   0.29       1.55 
 56 Slovak Republic                Europe & Central Asia      1.3    0.27       1.57 
 57 United Kingdom                 Europe & Central Asia      1.64  -0.0700     1.57 
 58 Isle of Man                    Europe & Central Asia      1.69  -0.123      1.57 
 59 Sint Maarten (Dutch part)      Latin America & Caribb…    1.85  -0.278      1.57 
 60 Armenia                        Europe & Central Asia      1.60  -0.0280     1.58 
 61 Antigua and Barbuda            Latin America & Caribb…    2.20  -0.616      1.58 
 62 Dominica                       Latin America & Caribb…    2.35  -0.763      1.59 
 63 Iceland                        Europe & Central Asia      2.08  -0.491      1.59 
 64 North Macedonia                Europe & Central Asia      1.86  -0.261      1.6  
 65 Trinidad and Tobago            Latin America & Caribb…    1.77  -0.155      1.61 
 66 Czechia                        Europe & Central Asia      1.15   0.468      1.62 
 67 Brazil                         Latin America & Caribb…    2.26  -0.629      1.63 
 68 Australia                      East Asia & Pacific        1.76  -0.126      1.63 
 69 Serbia                         Europe & Central Asia      1.48   0.150      1.63 
 70 Barbados                       Latin America & Caribb…    1.78  -0.141      1.63 
 71 Turks and Caicos Islands       Latin America & Caribb…    2.51  -0.853      1.66 
 72 New Zealand                    East Asia & Pacific        1.98  -0.32       1.66 
 73 United States                  North America              2.06  -0.391      1.66 
 74 Azerbaijan                     Europe & Central Asia      2     -0.33       1.67 
 75 Maldives                       South Asia                 2.71  -1.03       1.68 
 76 Iran, Islamic Rep.             Middle East & North Af…    2.02  -0.335      1.68 
 77 French Polynesia               East Asia & Pacific        2.60  -0.908      1.69 
 78 Colombia                       Latin America & Caribb…    2.57  -0.88       1.69 
 79 Ireland                        Europe & Central Asia      1.89  -0.19       1.7  
 80 Brunei Darussalam              East Asia & Pacific        2.35  -0.582      1.76 
 81 St. Vincent and the Grenadines Latin America & Caribb…    2.34  -0.562      1.78 
 82 Bulgaria                       Europe & Central Asia      1.26   0.52       1.78 
 83 Qatar                          Middle East & North Af…    3.23  -1.45       1.78 
 84 El Salvador                    Latin America & Caribb…    3.14  -1.36       1.78 
 85 Malaysia                       East Asia & Pacific        2.91  -1.13       1.79 
 86 Korea, Dem. People's Rep.      East Asia & Pacific        1.97  -0.176      1.79 
 87 France                         Europe & Central Asia      1.89  -0.0960     1.79 
 88 Bahrain                        Middle East & North Af…    2.78  -0.981      1.80 
 89 Moldova                        Europe & Central Asia      1.50   0.301      1.8  
 90 Montenegro                     Europe & Central Asia      2.06  -0.265      1.8  
 91 Mexico                         Latin America & Caribb…    2.72  -0.913      1.80 
 92 Romania                        Europe & Central Asia      1.31   0.5        1.81 
 93 Palau                          East Asia & Pacific        1.83   0          1.83 
 94 Gibraltar                      Europe & Central Asia      1.92  -0.0820     1.84 
 95 Greenland                      Europe & Central Asia      2.33  -0.49       1.84 
 96 Argentina                      Latin America & Caribb…    2.59  -0.715      1.88 
 97 Cabo Verde                     Sub-Saharan Africa         3.54  -1.66       1.88 
 98 Türkiye                        Europe & Central Asia      2.50  -0.623      1.88 
 99 Viet Nam                       East Asia & Pacific        2.07  -0.131      1.94 
100 Bangladesh                     South Asia                 3.22  -1.27       1.95 
101 Sri Lanka                      South Asia                 2.19  -0.217      1.97 
102 Grenada                        Latin America & Caribb…    2.58  -0.596      1.99 
103 Belize                         Latin America & Caribb…    3.63  -1.64       1.99 
104 Virgin Islands (U.S.)          Latin America & Caribb…    2.06  -0.0600     2    
105 Ecuador                        Latin America & Caribb…    3.10  -1.10       2.00 
106 Nepal                          South Asia                 3.94  -1.94       2.01 
107 India                          South Asia                 3.35  -1.34       2.01 
108 New Caledonia                  East Asia & Pacific        2.59  -0.57       2.02 
109 Faroe Islands                  Europe & Central Asia      2.58  -0.532      2.05 
110 Georgia                        Europe & Central Asia      1.60   0.462      2.06 
111 Tunisia                        Middle East & North Af…    2.05   0.0150     2.06 
112 Lebanon                        Middle East & North Af…    2.50  -0.419      2.08 
113 Kuwait                         Middle East & North Af…    2.74  -0.645      2.09 
114 Myanmar                        East Asia & Pacific        2.78  -0.658      2.13 
115 Indonesia                      East Asia & Pacific        2.54  -0.383      2.15 
116 Peru                           Latin America & Caribb…    2.84  -0.681      2.16 
117 Dominican Republic             Latin America & Caribb…    2.86  -0.612      2.25 
118 Nicaragua                      Latin America & Caribb…    3.11  -0.827      2.28 
119 Panama                         Latin America & Caribb…    2.74  -0.447      2.30 
120 Morocco                        Middle East & North Af…    2.80  -0.497      2.30 
121 Seychelles                     Sub-Saharan Africa         2.08   0.240      2.32 
122 Cambodia                       East Asia & Pacific        3.77  -1.45       2.32 
123 Suriname                       Latin America & Caribb…    2.90  -0.573      2.32 
124 Honduras                       Latin America & Caribb…    4.24  -1.90       2.34 
125 South Africa                   Sub-Saharan Africa         2.41  -0.0720     2.34 
126 Guatemala                      Latin America & Caribb…    4.58  -2.23       2.35 
127 Guyana                         Latin America & Caribb…    3.02  -0.648      2.37 
128 St. Martin (French part)       Latin America & Caribb…    2.71  -0.329      2.38 
129 Saudi Arabia                   Middle East & North Af…    4.12  -1.72       2.39 
130 Libya                          Middle East & North Af…    2.85  -0.449      2.40 
131 Paraguay                       Latin America & Caribb…    3.55  -1.11       2.44 
132 Lao PDR                        East Asia & Pacific        4.4   -1.95       2.45 
133 Fiji                           East Asia & Pacific        3.03  -0.564      2.46 
134 Guam                           East Asia & Pacific        3.01  -0.457      2.55 
135 Oman                           Middle East & North Af…    3.89  -1.33       2.57 
136 Bolivia                        Latin America & Caribb…    3.99  -1.41       2.58 
137 Turkmenistan                   Europe & Central Asia      2.90  -0.281      2.62 
138 Micronesia, Fed. Sts.          East Asia & Pacific        4.28  -1.61       2.67 
139 Marshall Islands               East Asia & Pacific        4.59  -1.92       2.67 
140 Syrian Arab Republic           Middle East & North Af…    4.00  -1.30       2.70 
141 Philippines                    East Asia & Pacific        3.71  -0.989      2.72 
142 Botswana                       Sub-Saharan Africa         3.31  -0.558      2.75 
143 Djibouti                       Middle East & North Af…    4.58  -1.82       2.76 
144 Haiti                          Latin America & Caribb…    4.39  -1.62       2.77 
145 Mongolia                       East Asia & Pacific        2.26   0.519      2.77 
146 Eswatini                       Sub-Saharan Africa         4.00  -1.21       2.78 
147 Jordan                         Middle East & North Af…    3.92  -1.13       2.79 
148 Kyrgyz Republic                Europe & Central Asia      2.4    0.4        2.8  
149 Algeria                        Middle East & North Af…    2.57   0.263      2.83 
150 Egypt, Arab Rep.               Middle East & North Af…    3.44  -0.564      2.88 
151 Israel                         Middle East & North Af…    2.95  -0.0600     2.89 
152 Lesotho                        Sub-Saharan Africa         3.66  -0.678      2.98 
153 Timor-Leste                    East Asia & Pacific        5.98  -2.93       3.05 
154 Kazakhstan                     Europe & Central Asia      1.8    1.25       3.05 
155 Tajikistan                     Europe & Central Asia      4.01  -0.865      3.14 
156 Tuvalu                         East Asia & Pacific        3.81  -0.663      3.14 
157 Papua New Guinea               East Asia & Pacific        4.53  -1.36       3.16 
158 Tonga                          East Asia & Pacific        4.11  -0.915      3.19 
159 Namibia                        Sub-Saharan Africa         3.98  -0.727      3.25 
160 Kiribati                       East Asia & Pacific        4.07  -0.794      3.27 
161 Kenya                          Sub-Saharan Africa         5.14  -1.84       3.30 
162 Uzbekistan                     Europe & Central Asia      2.58   0.728      3.31 
163 Pakistan                       South Asia                 5.26  -1.85       3.41 
164 West Bank and Gaza             Middle East & North Af…    5.44  -2.01       3.44 
165 Zimbabwe                       Sub-Saharan Africa         3.97  -0.537      3.44 
166 Iraq                           Middle East & North Af…    4.95  -1.50       3.44 
167 Gabon                          Sub-Saharan Africa         4.47  -1.01       3.46 
168 Nauru                          East Asia & Pacific        3.64  -0.179      3.46 
169 Ghana                          Sub-Saharan Africa         4.85  -1.35       3.51 
170 Vanuatu                        East Asia & Pacific        4.48  -0.783      3.70 
171 Yemen, Rep.                    Middle East & North Af…    6.32  -2.60       3.72 
172 Rwanda                         Sub-Saharan Africa         5.92  -2.18       3.75 
173 São Tomé and Principe          Sub-Saharan Africa         5.18  -1.43       3.75 
174 Eritrea                        Sub-Saharan Africa         5.40  -1.61       3.79 
175 Madagascar                     Sub-Saharan Africa         5.40  -1.61       3.79 
176 Malawi                         Sub-Saharan Africa         6.04  -2.19       3.85 
177 Samoa                          East Asia & Pacific        4.51  -0.639      3.88 
178 Sierra Leone                   Sub-Saharan Africa         6.36  -2.48       3.88 
179 Comoros                        Sub-Saharan Africa         5.30  -1.38       3.91 
180 Guinea-Bissau                  Sub-Saharan Africa         5.72  -1.80       3.92 
181 Solomon Islands                East Asia & Pacific        4.76  -0.831      3.92 
182 Liberia                        Sub-Saharan Africa         5.88  -1.86       4.02 
183 Ethiopia                       Sub-Saharan Africa         6.56  -2.50       4.06 
184 Congo, Rep.                    Sub-Saharan Africa         4.76  -0.669      4.10 
185 Equatorial Guinea              Sub-Saharan Africa         5.83  -1.66       4.17 
186 Togo                           Sub-Saharan Africa         5.27  -1.07       4.20 
187 Zambia                         Sub-Saharan Africa         5.93  -1.68       4.24 
188 Guinea                         Sub-Saharan Africa         5.94  -1.63       4.30 
189 Senegal                        Sub-Saharan Africa         5.50  -1.18       4.31 
190 South Sudan                    Sub-Saharan Africa         7.51  -3.18       4.34 
191 Côte d'Ivoire                  Sub-Saharan Africa         5.81  -1.47       4.34 
192 Mauritania                     Sub-Saharan Africa         5.46  -1.12       4.34 
193 Cameroon                       Sub-Saharan Africa         5.53  -1.15       4.38 
194 Sudan                          Sub-Saharan Africa         5.38  -0.996      4.38 
195 Uganda                         Sub-Saharan Africa         6.83  -2.36       4.47 
196 Afghanistan                    South Asia                 7.53  -3.01       4.52 
197 Mozambique                     Sub-Saharan Africa         5.81  -1.25       4.56 
198 Gambia, The                    Sub-Saharan Africa         5.80  -1.21       4.59 
199 Tanzania                       Sub-Saharan Africa         5.69  -1.03       4.66 
200 Burkina Faso                   Sub-Saharan Africa         6.52  -1.85       4.66 
201 Benin                          Sub-Saharan Africa         5.89  -0.995      4.89 
202 Burundi                        Sub-Saharan Africa         6.87  -1.89       4.98 
203 Nigeria                        Sub-Saharan Africa         6.12  -0.981      5.14 
204 Angola                         Sub-Saharan Africa         6.64  -1.43       5.21 
205 Mali                           Sub-Saharan Africa         6.87  -1.01       5.87 
206 Central African Republic       Sub-Saharan Africa         5.92   0.00300    5.92 
207 Congo, Dem. Rep.               Sub-Saharan Africa         6.72  -0.612      6.11 
208 Somalia                        Sub-Saharan Africa         7.61  -1.41       6.20 
209 Chad                           Sub-Saharan Africa         7.25  -1.03       6.22 
210 Niger                          Sub-Saharan Africa         7.73  -0.983      6.75 
```
:::
