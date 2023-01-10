select * from dbo.CovidVaccinations
select * from dbo.CovidDeaths

select location, date, total_cases, total_deaths , new_cases,  new_deaths   from dbo.CovidDeaths
order by 1, 2
 

 --To find max infected rate from each country
 select location, population, max(total_cases) as highest_Infected, max((total_cases/population))*100 as Infected_rate  from dbo.CovidDeaths
 group by location, population
 order by location


 --To find number of cases and deaths in the world based on date
 SELECT date, SUM(new_cases) total_cases, SUM(CAST(new_deaths AS INT)) total_deaths FROM dbo.CovidDeaths 
 GROUP BY date
 ORDER BY date

 --To find number of people got vaccinated
 SELECT cv.continent, cv.location,cv.date, cd.population,cv.new_vaccinations FROM dbo.CovidVaccinations cv
 JOIN dbo.CovidDeaths cd
 ON cv.location = cd.location
 AND cv.date = cd.date
 WHERE cd.continent IS NOT NULL
 ORDER BY 1,2,3


 --To get sum of vaccinations based on location
 SELECT cv.continent, cv.location,cv.date, cd.population,cv.new_vaccinations, SUM(CONVERT(INT,cv.new_vaccinations)) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.date)
 FROM dbo.CovidVaccinations cv
 JOIN dbo.CovidDeaths cd
 ON cv.location = cd.location
 AND cv.date = cd.date
 WHERE cd.continent IS NOT NULL
 ORDER BY 2,3

 --To get percentage of population got vaccinated
 WITH populationvsvaccination(continent, location, date, population, new_vaccinations, Rollingpeoplevaccinated)
 as
 (
 SELECT cv.continent, cv.location,cv.date, cd.population,cv.new_vaccinations, SUM(CONVERT(INT,cv.new_vaccinations)) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.date) Rollingpeoplevaccinated
 FROM dbo.CovidVaccinations cv
 JOIN dbo.CovidDeaths cd
 ON cv.location = cd.location
 AND cv.date = cd.date
 WHERE cd.continent IS NOT NULL
 )
 SELECT *, (Rollingpeoplevaccinated/population)*100 FROM populationvsvaccination
 ORDER BY location, date



 -- Creating view to store data for later visualizations
 CREATE VIEW percentagepopulationvaccinated AS 

 SELECT cv.continent, cv.location,cv.date, cd.population,cv.new_vaccinations, SUM(CONVERT(INT,cv.new_vaccinations)) OVER(PARTITION BY cd.location ORDER BY cd.location, cd.date) Rollingpeoplevaccinated
 FROM dbo.CovidVaccinations cv
 JOIN dbo.CovidDeaths cd
 ON cv.location = cd.location
 AND cv.date = cd.date
 WHERE cd.continent IS NOT NULL

 