

# Advanced operations

In this chapter, we will cover a few more advanced, yet incredibly useful data tidying operations like grouping, joining, and pivoting. Along the way, we will also make extensive use of dplyr functions learned in the previous chapter.


## Grouping

Often, you will need to apply dplyr's various operations like `mutate()`, `summarize()`, or slicing function not across the entire dataset but in groups. This is an important technique across data science, whether it's data cleaning to exploration to visualization to modeling.

By default, data frames are not grouped when created or imported. You can create a grouping structure with the `group_by()` function. The basic syntax is `df %>% group_by(col1, col2, ...)` where `col1`, `col2`, ... are variables whose values are used to determine groups. You can group by just 1 variable, 2 variables, or as many variables as needed. **Rows with the same values in the chosen columns will be grouped together**.

After grouping, operations that normally run across all rows **now run across each group**. Here's a few simple examples using the familiar penguins dataset to start:


``` r
# import tidyverse and load dataset
library(tidyverse)
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

